require 'mechanize'

module ContentDM
	class Photos
		class << self
			CONTENTDM_URL = 'http://www.kchistory.org/cdm4/'
			EXCLUDED_COLLECTIONS = ['Local', 'Sanborn']
			COMMON_FALSE_POSITIVES = ['Missouri', 'Kansas', 'Park']
			TIMEOUT = 90
			PAUSE = 2
			RETRIES = 4


			LOGGER = ActiveSupport::Logger.new('log/photos.log')

			# Pulls photos from ContentDM API and creates records
			def create_photos
				harvester = ContentDm::Harvester.new(CONTENTDM_URL)

				harvester.collections.each do |name, desc|
					next if name.in? EXCLUDED_COLLECTIONS

					LOGGER.add 0, "INFO: Harvesting the #{name} collection"

					harvester.get_records(name).each do |record|
						next unless record.metadata['dc.type'].any? { |type| type.include? 'Photo' }
						next if Photo.exists?(image_url: record.img_href.to_s)

						# Scrape dimensions from the permalink
						agent = Mechanize.new
						agent.follow_meta_refresh = true
						attempts = 0
						begin
							attempts += 1
							form = agent.get(record.permalink, timeout: 120).form('mainimage')
							width = form.field_with(name: 'DMWIDTH').value.to_i
							height = form.field_with(name: 'DMHEIGHT').value.to_i
						rescue StandardError => e
							if attempts <= RETRIES
								LOGGER.add 0, "WARN: Encountered error, retry #{attempts} of #{RETRIES}"
								sleep(attempts < RETRIES ? PAUSE : TIMEOUT)
								retry
							else
								LOGGER.add 0, "ERROR: Failed to get dimensions for photo with image_url #{record.img_href}, message: #{e.message}"
								width = 0
								height = 0
							end
						ensure
							sleep(PAUSE)
						end

						Photo.create!(
							name: record.metadata['dc.title'].first,
							description: record.metadata['dc.description'].first || '',
							image_url: record.img_href,
							thumbnail_url: record.thumbnail_href,
							date: record.metadata['dc.date'].first,
							tags: record.metadata['dc.subject'].join('; '),
							width: width,
							height: height,
							active: false
						)

						# Pause to limit the load created from scraping the site
						sleep 5
					end
				end
			end

			def street_name(street)
				street.gsub('Northeast', '').gsub('Northwest', '')
					.gsub('Southeast', '').gsub('Southwest', '')
					.gsub('East', '').gsub('West', '')
					.gsub('North', '').gsub('South', '')
					.gsub(/Street$/, '').gsub(/Terrace$/, '')
					.gsub(/Boulevard$/, '').gsub(/Parkway$/, '')
					.gsub(/Avenue$/, '').gsub(/Road$/, '')
					.gsub(/Circle$/, '').gsub(/Place$/, '')
					.gsub(/Lane$/, '').gsub(/Drive$/, '')
					.gsub(/Trafficway$/, '')
			end

			def assign_locations
				Photo.where(location_id: nil).each do |photo|
					located = false

					# Check tags to map locations
					subjects = photo.tags.split('; ')
					northerized = subjects.map { |subject| "North #{subject}" }
					easterized = subjects.map { |subject| "East #{subject}" }
					southerized = subjects.map { |subject| "South #{subject}" }
					westerized = subjects.map { |subject| "West #{subject}" }
					directionized = subjects + northerized + easterized + southerized + westerized
					combos = directionized.product(directionized)

					combos.each do |subjects|
						break if located

						location = Location.find_by(street1: subjects.first, street2: subjects.second)
						if location.present?
							LOGGER.add 0, "INFO: Mapped photo ##{photo.id} to location ##{location.id}"
							photo.location = location
							photo.save!
							located = true
							break
						end
					end
					break if located

					# Parse the description to map locations
					Location.all.each do |location|
						street1 = street_name(location.street1).strip
						street2 = street_name(location.street2).strip
						next if street1.blank? || street2.blank? || street1 == street2
						next if COMMON_FALSE_POSITIVES.include?(street1) || COMMON_FALSE_POSITIVES.include?(street2)

						if photo.description.include?(street1) && photo.description.include?(street2)
							LOGGER.add 0, "INFO: Mapped photo ##{photo.id} to location ##{location.id}"
							photo.location = location
							photo.save!
							located = true
							break
						end
					end
				end
			end
		end
	end
end
