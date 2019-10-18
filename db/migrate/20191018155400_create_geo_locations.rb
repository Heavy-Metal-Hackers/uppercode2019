class CreateGeoLocations < ActiveRecord::Migration
  def self.up
    create_table :geo_locations do |t|
      t.string :geo_id

      t.string :link
      t.string :description
      t.string :short_description
      t.string :name
      t.string :keywords # comma separated
      t.string :image

      t.string :polygon
      t.integer :difficulty
      t.integer :length
      t.integer :duration
      t.integer :altitude_difference
      t.boolean :round_tour
      t.boolean :rest_stop
      t.integer :elev_min
      t.integer :elev_max
      t.string :elev_image
      t.string :gpx_link

      t.boolean :family_friendly
      t.boolean :barrier_free_info

      t.references :address, index: true
      t.references :contact_address, index: true

      t.string :tel
      t.string :email
      t.string :contact_email
      t.string :contact_link

      t.boolean :active

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :geo_locations
  end
end
