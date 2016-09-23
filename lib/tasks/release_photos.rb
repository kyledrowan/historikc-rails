require_relative '../release_content'

namespace :release_content do
  desc "Creates a migration to release all new and updated photos"
  task photos: :environment do
  	Content.release('photos')
  end
end
