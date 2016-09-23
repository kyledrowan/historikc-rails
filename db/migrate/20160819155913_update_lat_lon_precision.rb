class UpdateLatLonPrecision < ActiveRecord::Migration
  def change
  	change_column :locations, :latitude, :decimal, precision: 13, scale: 9
  	change_column :locations, :longitude, :decimal, precision: 13, scale: 9
  end
end
