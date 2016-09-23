require_relative '../open_street_map'

namespace :open_street_map do
  desc "Creates locations based on OpenStreetMap intersections"
  task create_locations: :environment do
  	OpenStreetMap::Locations.create_locations
  end
end
