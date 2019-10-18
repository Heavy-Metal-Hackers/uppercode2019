class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|

      t.references :guest, index: true

      t.datetime :started_at
      
      t.boolean :active

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :chats
  end
end