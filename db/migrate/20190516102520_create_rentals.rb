class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.string :name
      t.integer :amount
      t.string :interval
      t.belongs_to :group, index: true
      t.string :stp_rental_id

      t.timestamps
    end
  end
end
