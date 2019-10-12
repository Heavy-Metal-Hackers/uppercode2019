class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|

      t.references :changed_by, index: true
      t.datetime :changed_at

      t.string :ticketnummer

      t.integer :status # enum :in_arbeit, :weitergeleitet, :gelöst, :geschlossen
      t.datetime :zielzeit
      t.string :dienstTechnik
      t.string :dienstProdukt
      t.string :problembeschreibung
      t.integer :problemtyp # enum :Kundenreklamation, Netzstoerung,
      #t.integer :ccb_Nummer TODO link to customer, has number and customer class
      t.integer :schweregrad # enum : Komplettausfall, Teilausfall, Critical, Minor
      t.integer :prio
      t.datetime :stoerungsbeginn
      t.datetime :stoerungsende
      t.boolean :proaktiv
      t.boolean :webIF
      t.string :loesungWas
      t.integer :verursacher # enum :Kunde, Vodafone, Nicht nachvollziehbar

      #t.references :create_user, index: true
      #t.references :update_user, index: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end