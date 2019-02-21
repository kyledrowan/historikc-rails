# frozen_string_literal: true

require_relative '../release_content'

namespace :release_content do
  desc 'Creates a migration to release all new and updated locations'
  task locations: :environment do
    Content.release('locations')
  end
end
