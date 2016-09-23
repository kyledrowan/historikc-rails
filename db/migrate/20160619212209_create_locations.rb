class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
    	t.string :name, null: false

    	t.decimal :latitude, null: false
    	t.decimal :longitude, null: false

    	t.string :street1
    	t.string :street2

    	t.boolean :active, null: false
    	t.timestamps null: false
    end
  end
end
