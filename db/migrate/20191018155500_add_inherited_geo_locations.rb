class AddInheritedGeoLocations < ActiveRecord::Migration
  def self.up
    add_column :geo_locations, :type, :string
  end

  def self.down
    remove_column :geo_locations, :type
  end
end
