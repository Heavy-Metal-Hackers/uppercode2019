class CreateCategories < ActiveRecord::Migration
  def change
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
end