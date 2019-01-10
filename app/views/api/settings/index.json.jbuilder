@settings.each do |setting|
  json.set! setting.name, setting.value
end

if @settings.pluck(:name).include? 'facility_types'
  json.set! 'facility_types', Setting::FACILITY_TYPES
end
