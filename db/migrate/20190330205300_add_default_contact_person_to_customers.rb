class AddDefaultContactPersonToCustomers < ActiveRecord::Migration
  def change
    add_reference :customers, :standardAnsprechpartner, index: true
  end
end