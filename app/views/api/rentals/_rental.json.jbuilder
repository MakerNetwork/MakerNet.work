json.extract! rental, :id, :base_name, :name, :interval, :interval_count, :group_id, :is_rolling, :description, :type, :ui_weight, :disabled
json.amount (rental.amount / 100.00)
json.prices rental.prices, partial: 'api/prices/price', as: :price
json.rental_file_attributes do
  json.id rental.rental_file.id
  json.attachment_identifier rental.rental_file.attachment_identifier
end if rental.rental_file

json.partners rental.partners do |partner|
  json.first_name partner.first_name
  json.last_name partner.last_name
  json.email partner.email
end if rental.respond_to?(:partners)
