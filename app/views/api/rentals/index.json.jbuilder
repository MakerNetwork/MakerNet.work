json.array!(@rentals) do |rental|
  json.extract! rental, :id, :base_name, :name, :interval, :interval_count, :group_id, :training_credit_nb, :description, :type, :ui_weight, :disabled
  json.amount (rental.amount / 100.00)
  json.rental_file_url rental.rental_file.attachment_url if rental.rental_file
end
