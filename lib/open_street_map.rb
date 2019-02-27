# frozen_string_literal: true

require 'overpass_api_ruby'

module OpenStreetMap
  class Locations
    class << self
      # from 38.991089, -94.611648 (SW corner) to 39.151158, -94.497210 (NE corner)
      GLOBAL_BOUNDARIES = { s: 38.991089, n: 39.151158, w: -94.611648, e: -94.497210 }.freeze
      STEP = 0.005
      TIMEOUT = 120
      PAUSE = 15
      RETRIES = 4

      LOGGER = ActiveSupport::Logger.new('log/locations.log')

      # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
      def create_locations
        LOGGER.add 0, 'INFO: Beginning location generation'
        overpass = OverpassAPI.new(timeout: TIMEOUT, json: true)

        row = 0
        total = 0

        # rubocop:disable Metrics/BlockLength
        (GLOBAL_BOUNDARIES[:s]...GLOBAL_BOUNDARIES[:n]).step(STEP) do |ns|
          row += 1
          column = 0

          (GLOBAL_BOUNDARIES[:w]...GLOBAL_BOUNDARIES[:e]).step(STEP) do |ew|
            column += 1
            total += 1
            attempts = 0
            boundaries = { s: ns, n: ns + STEP, w: ew, e: ew + STEP }
            LOGGER.add 0, "INFO: Beginning row #{row}, column #{column} (#{boundaries})"

            begin
              attempts += 1
              overpass.query(query(boundaries)).slice_before { |result| result[:type] == 'node' }.each do |node_set|
                node_group = node_set.group_by { |item| item[:type] }

                streets = node_group['way']
                next if streets.blank?

                # We're only concerned with certain streets
                streets = streets.select { |way| way[:tags][:highway].present? }
                streets = streets.select { |way| way[:tags][:name].present? }
                streets = streets.select { |way| %w[footway cycleway path service track].exclude? way[:tags][:highway] }

                # Deduplicate names on four fields if they are present
                streets = streets.uniq { |way| strip_direction(way[:tags][:name]) }
                streets = streets.uniq { |way| strip_direction(way[:tags][:name_1]) || rand }
                streets = streets.uniq { |way| way[:tags][:'tiger:name_base'] || rand }
                streets = streets.uniq { |way| way[:tags][:'tiger:name_base_1'] || rand }

                streets = streets.map { |way| way[:tags][:name] }
                streets = streets.sort_by { |way| way.scan(/(?=\d)/).length }.reverse

                node = node_group['node'].first
                next if node.blank?

                lat_lon_duplicate = Location.where(latitude: node[:lat], longitude: node[:lon]).first

                street_duplicate = Location.where(
                  '(street1 = ? AND street2 = ?) OR (street2 = ? AND street1 = ?)',
                  streets.first,
                  streets.second,
                  streets.first,
                  streets.second,
                ).first

                if lat_lon_duplicate.present?
                  LOGGER.add(
                    0,
                    'WARN: Found multiple street pairs at same lat/lon. '\
                    "Found #{streets.first} & #{streets.last}, had #{street_duplicate}",
                  )
                elsif streets.try(:length) != 2
                  LOGGER.add 0, "WARN: Node didn't have 2 ways #{streets} (#{node[:lat]}, #{node[:lon]})"
                elsif street_duplicate.present?
                  LOGGER.add(
                    0,
                    "INFO: Adding #{humanize_street(streets.first)} & #{humanize_street(streets.second)} "\
                    'at midpoint & removed previous location',
                  )
                  Location.create!(
                    latitude: (street_duplicate.latitude + node[:lat]) / 2,
                    longitude: (street_duplicate.longitude + node[:lon]) / 2,
                    active: false,
                    street1: streets.first,
                    street2: streets.second,
                    name: "#{humanize_street(streets.first)} & #{humanize_street(streets.second)}",
                  )
                  street_duplicate.destroy!
                else
                  LOGGER.add 0, "INFO: Adding #{humanize_street(streets.first)} & #{humanize_street(streets.second)}"
                  Location.create!(
                    latitude: node[:lat],
                    longitude: node[:lon],
                    active: false,
                    street1: streets.first,
                    street2: streets.second,
                    name: "#{humanize_street(streets.first)} & #{humanize_street(streets.second)}",
                  )
                end
              end
            rescue StandardError => e
              if attempts <= RETRIES
                LOGGER.add 0, "WARN: Encountered error, retry #{attempts} of #{RETRIES}"
                sleep(attempts < RETRIES ? PAUSE : TIMEOUT)
                retry
              else
                LOGGER.add 0, "ERROR: #{e.message}"
              end
            ensure
              sleep(PAUSE)
            end
          end
          # rubocop:enable Metrics/BlockLength
        end
        LOGGER.add 0, "INFO: Total requests: #{total}"
      end
      # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/MethodLength

      private

      def humanize_street(street)
        street.gsub('Northeast', 'NE').gsub('Northwest', 'NW')
              .gsub('Southeast', 'SE').gsub('Southwest', 'SW')
              .gsub('East', 'E').gsub('West', 'W')
              .gsub('North', 'N').gsub('South', 'S')
              .gsub(/Street$/, 'St').gsub(/Terrace$/, 'Ter')
              .gsub(/Boulevard$/, 'Blvd').gsub(/Parkway$/, 'Pkwy')
              .gsub(/Avenue$/, 'Ave').gsub(/Road$/, 'Rd')
              .gsub(/Circle$/, 'Cir').gsub(/Place$/, 'Pl')
              .gsub(/Lane$/, 'Ln').gsub(/Drive$/, 'Dr')
      end
      # rubocop:enable Metrics/AbcSize

      def strip_direction(street)
        return nil if street.nil?

        street.sub(/^(N|S|E|W|NW|NE|SE|SW|North|South|East|West|Northwest|Northeast|Southeast|Southwest)\s*/, '')
      end

      def query(boundaries)
        <<~QUERY
          <query type="way" into="hw">
            <has-kv k="highway"/>
            <has-kv k="highway" modv="not" regv="footway|cycleway|path|service|track"/>
            <bbox-query n="#{boundaries[:n]}" e="#{boundaries[:e]}" s="#{boundaries[:s]}" w="#{boundaries[:w]}"/>
          </query>
          <foreach from="hw" into="w">
            <recurse from="w" type="way-node" into="ns"/>
            <recurse from="ns" type="node-way" into="w2"/>
            <query type="way" into="w2">
              <item set="w2"/>
              <has-kv k="highway"/>
              <has-kv k="highway" modv="not" regv="footway|cycleway|path|service|track"/>
            </query>
            <difference into="wd">
              <item set="w2"/>
              <item set="w"/>
            </difference>
            <recurse from="wd" type="way-node" into="n2"/>
            <recurse from="w"  type="way-node" into="n3"/>
            <query type="node">
              <item set="n2"/>
              <item set="n3"/>
              <bbox-query n="#{boundaries[:n]}" e="#{boundaries[:e]}" s="#{boundaries[:s]}" w="#{boundaries[:w]}"/>
            </query>
            <foreach>
              <union>
                <item/>
                <recurse type="node-way"/>
              </union>
            <print/>
            </foreach>
          </foreach>
        QUERY
      end
    end
  end
end
