class CreateCategorySets < ActiveRecord::Migration
  def self.up
    create_table :category_sets do |t|

      t.string :category_type
      t.string :name

      t.boolean :active

      t.timestamps null: false
    end

    add_index :category_sets, [:category_type], unique: true
  end

  def self.down
    drop_table :category_sets
  end
end