class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|

      t.references :customer, index: true
      t.references :contact_person, index: true

      t.datetime :started_at
      
      t.boolean :active

      t.timestamps null: false
    end
  end
end