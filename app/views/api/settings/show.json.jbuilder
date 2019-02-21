if @setting.name.eql? 'facility_types'
  json.setting do
    json.name 'facility_types'
    json.value Setting::FACILITY_TYPES
  end
else
  json.setting do
    json.partial! 'api/settings/setting', setting: @setting
  end
end
