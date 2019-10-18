class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|

      t.string :key

      t.string :name
      t.string :pin
      t.string :schemaorg_id

      t.references :parent_category, index: true
      t.references :category_set, index: true
      
      t.boolean :active

      t.timestamps null: false
    end

    add_index :categories, [:key], unique: true
  end

  def self.down
    drop_table :categories
  end
end