class CreateGuests < ActiveRecord::Migration
  def self.up
    create_table :guests do |t|

      t.string :name

      #t.references :create_user, index: true
      #t.references :update_user, index: true

      t.boolean :active

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :guests
  end
end