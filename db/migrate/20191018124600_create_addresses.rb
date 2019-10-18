class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street
      t.string :street_no
      t.string :street_no_addition
      t.string :zip_code
      t.string :city
      t.decimal :lat, scale: 8, precision: 12
      t.decimal :lng, scale: 8, precision: 12
      t.boolean :active

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :addresses
  end
end
