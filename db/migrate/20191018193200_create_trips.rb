class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.boolean :active

      t.references :guest, index: true

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :trips
  end
end