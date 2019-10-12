class CreateContactPeople < ActiveRecord::Migration
  def change
    create_table :contact_people do |t|

      t.references :customer, index: true

      t.string :email
      t.string :phone
      t.string :name
      #t.references :create_user, index: true
      #t.references :update_user, index: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end