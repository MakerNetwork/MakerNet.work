class AddAttributesToRental < ActiveRecord::Migration
  def change
    add_column :rentals, :is_rolling, :boolean, default: true
    add_column :rentals, :description, :text
    add_column :rentals, :type, :string
  end
end
