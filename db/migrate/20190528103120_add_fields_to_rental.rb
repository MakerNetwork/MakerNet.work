class AddFieldsToRental < ActiveRecord::Migration
  def change
  	add_column :rentals, :base_name, :string
	add_column :rentals, :ui_weight, :integer, default: 0
	add_column :rentals, :interval_count, :integer, default: 1
	add_column :rentals, :slug, :string
	add_column :rentals, :disabled, :boolean
	add_column :rentals, :training_credit_nb, :integer, default: 0
  end
end
