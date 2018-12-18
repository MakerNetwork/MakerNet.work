module AvailabilitiesConcern
  def display_reservation_user_name?(user_role)
    if user_role == 'admin'
      true
    else
      enabled = Setting.find_by(name: 'display_name_enable')
      enabled ? { 'true' => true, 'false' => false }[enabled] : false
    end
  end
end
