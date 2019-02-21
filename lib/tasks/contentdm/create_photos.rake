# frozen_string_literal: true

require_relative '../../contentdm'

namespace :contentdm do
  desc 'Creates photos from the online ContentDM repository'
  task create_photos: :environment do
    ContentDM::Photos.create_photos
  end
end
