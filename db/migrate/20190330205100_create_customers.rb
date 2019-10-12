class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|

      t.string :ccb_Nummer

      t.string :serviceLevel # enum :in_arbeit, :weitergeleitet, :gelöst, :geschlossen
      t.string :kundenklasse
      t.string :name
      #t.references :create_user, index: true
      #t.references :update_user, index: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end