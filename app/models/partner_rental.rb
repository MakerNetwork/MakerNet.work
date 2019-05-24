class PartnerRental < Rental
  resourcify

  before_create :assign_default_values

  def partners
    User.joins(:roles).where(roles: { name: 'partner', resource_type: 'PartnerRental', resource_id: self.id })
  end

  private
  def assign_default_values
    assign_attributes(is_rolling: false)
  end
end
