class CreateChatNodes < ActiveRecord::Migration
  def change
    create_table :chat_nodes do |t|

      t.references :chat, index: true

      t.string :message
      t.integer :direction # enum: out, in, event
      t.datetime :timestamp

      t.boolean :active

      t.timestamps null: false
    end
  end
end