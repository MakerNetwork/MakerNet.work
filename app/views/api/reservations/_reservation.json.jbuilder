json.id reservation.id
json.user_id reservation.user_id
json.exist_user !reservation.user.nil?
json.user_full_name reservation.get_user_profile_full_name
json.message reservation.message
json.slots reservation.slots do |s|
  json.id s.id
  json.start_at s.start_at.iso8601
  json.end_at s.end_at.iso8601
end
json.nb_reserve_places reservation.nb_reserve_places
json.tickets reservation.tickets do |t|
  json.extract! t, :booked, :created_at
  json.event_price_category do
    json.extract! t.event_price_category, :id, :price_category_id
    json.price_category do
      json.extract! t.event_price_category.price_category, :id, :name
    end
  end
end
json.total_booked_seats reservation.total_booked_seats
json.created_at reservation.created_at.iso8601
json.reservable_id reservation.reservable_id
json.reservable_type reservation.reservable_type
