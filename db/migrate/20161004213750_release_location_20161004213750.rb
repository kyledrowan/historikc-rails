class ReleaseLocation20161004213750 < ActiveRecord::Migration
  def change
    Location.create!(id: '15269', name: 'Liberty Memorial Mall', latitude: '39.079787', longitude: '-94.586369', street1: 'Liberty Memorial Mall N', street2: 'Liberty Memorial Mall S', active: 'true', created_at: '2016-10-01 17:45:40 UTC', updated_at: '2016-10-01 17:45:40 UTC', ) 

  end
end
