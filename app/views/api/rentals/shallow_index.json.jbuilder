json.array!(@rentals) do |rental|
  json.id rental.id
  #json.ui_weight rental.ui_weight
  json.group_id rental.group_id
  json.base_name rental.base_name
  json.amount rental.amount / 100.0
  json.interval rental.interval
  json.interval_count rental.interval_count
  json.type rental.type
  json.disabled rental.disabled
  #json.rental_file_url rental.rental_file.attachment_url if rental.rental_file
end
