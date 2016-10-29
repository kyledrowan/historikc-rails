class ReleaseLocation20161029132138 < ActiveRecord::Migration
  def change
    Location.create!(id: '15271', name: 'Avenida Cesar E Chavez & Mercier St', latitude: '39.086042', longitude: '-94.599533', street1: 'Avenida Cesar E Chavez', street2: 'Mercier St', active: 'true', created_at: '2016-10-29 16:34:44 UTC', updated_at: '2016-10-29 16:34:44 UTC', ) 
    Location.create!(id: '15272', name: 'Independence Ave & Garfield Ave', latitude: '39.106533', longitude: '-94.557176', street1: 'Independence Ave', street2: 'Garfield Ave', active: 'true', created_at: '2016-10-29 17:35:11 UTC', updated_at: '2016-10-29 17:35:11 UTC', ) 

  end
end
