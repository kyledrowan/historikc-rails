# frozen_string_literal: true

require_relative '../../contentdm'

namespace :contentdm do
  desc "Assigns photos (created using 'rake contentdm:create_photos') to a location"
  task assign_locations: :environment do
    ContentDM::Photos.assign_locations
  end
end
