class CreateJoinTableGeoLocationCategory < ActiveRecord::Migration
  def change
    create_join_table :geo_locations, :categories do |t|
      t.index [:geo_location_id, :category_id], name: :index_geo_location_to_category
      t.index [:category_id, :geo_location_id], name: :index_category_to_geo_location
    end
    #add_foreign_key :geo_locations_categories, :geo_locations
    #add_foreign_key :geo_locations_categories, :categories
  end
end