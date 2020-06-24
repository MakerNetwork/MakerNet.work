json.array!(@rentals) do |rental|
  json.extract! rental, :id, :base_name, :name, :interval, :interval_count, :group_id, :training_credit_nb, :description, :type, :ui_weight, :disabled, :space_id
  json.amount (rental.amount / 100.00)
  #json.plan_file_url rental.plan_file.attachment_url if plan.rental_file
end
