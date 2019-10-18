class CreateTripDestinations < ActiveRecord::Migration
  def self.up
    create_table :trip_destinations do |t|
      t.references :geo_location, index: true
      t.references :trip, index: true

      t.datetime :date
      
      t.boolean :active

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :trip_destinations
  end
end