class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
    	t.string :name, null: false
    	t.text :description, null: false
      t.text :tags
      t.string :date

      t.string :image_url, null: false
      t.string :thumbnail_url, null: false
      t.integer :width, null: false
      t.integer :height, null: false

      t.string :address
      t.decimal :latitude
      t.decimal :longitude
      t.integer :angle

    	t.integer :location_id

      t.boolean :active, null: false
      t.timestamps null: false
    end
  end
end
