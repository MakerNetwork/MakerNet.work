class AddSpaceToRental < ActiveRecord::Migration
  def change
    add_reference :rentals, :space, index: true, foreign_key: true
  end
end
