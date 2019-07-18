class Rental < ActiveRecord::Base
  belongs_to :group

  has_many :credits, dependent: :destroy
  #has_many :training_credits, -> {where(creditable_type: 'Training')}, class_name: 'Credit'
  #has_many :machine_credits, -> {where(creditable_type: 'Machine')}, class_name: 'Credit'
  #has_many :space_credits, -> {where(creditable_type: 'Space')}, class_name: 'Credit'
  has_many :rental_subscriptions
  #has_one :plan_image, as: :viewable, dependent: :destroy
  has_one :plan_file, as: :viewable, dependent: :destroy
  has_many :prices, dependent: :destroy

  extend FriendlyId
  friendly_id :base_name, use: :slugged

  accepts_nested_attributes_for :prices
  #accepts_nested_attributes_for :plan_file_file, allow_destroy: true, reject_if: :all_blank

  after_update :update_stripe_rental, if: :amount_changed?
  after_create :create_stripe_rental, unless: :skip_create_stripe_rental
  after_create :create_rentals_prices
  after_destroy :delete_stripe_rental

  attr_accessor :skip_create_stripe_rental

  validates :amount, :group, :base_name, presence: true
  validates :interval_count, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :interval_count, numericality: { less_than: 12 }, if: Proc.new {|rental| rental.interval == 'month'}
  validates :interval_count, numericality: { less_than: 52 }, if: Proc.new {|rental| rental.interval == 'week'}
  validates :interval, inclusion: { in: %w(year month week) }
  validates :base_name, :slug, presence: true


  def self.create_for_all_groups(rental_params)
    rentals = []
    Group.all.each do |group|
      if rental_params[:type] == 'PartnerRental'
        rental = PartnerRental.new(rental_params.except(:group_id, :type))
      else
        rental = Rental.new(rental_params.except(:group_id, :type))
      end
      rental.group = group
      if rental.save
        rentals << rental
      else
        rentals.each(&:destroy)
        return false
      end
    end
    return rentals
  end

  def destroyable?
    rental_subscriptions.empty?
  end


  def create_rentals_prices
    Space.all.each do |space|
      Price.create(priceable: space, plan: self, group_id: self.group_id, amount: 0)
    end
  end

  def duration
    interval_count.send(interval)
  end

  def human_readable_duration
    i18n_key = "duration.#{interval}"
    "#{I18n.t(i18n_key, count: interval_count)}"
  end

  def human_readable_name(opts = {})
    result = "#{base_name}"
    result += " - #{group.slug}" if opts[:group]
    result + " - #{human_readable_duration}"
  end


  private
  def create_stripe_rental
    stripe_rental = Stripe::Plan.create(
      amount: amount,
      interval: interval,
      interval_count: interval_count,
      name: "#{base_name} - #{group.name} - #{interval}",
      currency: Rails.application.secrets.stripe_currency,
      id: "#{base_name.parameterize}-#{group.slug}-#{interval}-#{DateTime.now.to_s(:number)}"
    )
    update_columns(stp_rental_id: stripe_rental.id, name: stripe_rental.name)
    stripe_rental
  end

  def create_statistic_subtype
    StatisticSubType.create!({key: self.slug, label: self.name})
  end

  def create_statistic_association(stat_type, stat_subtype)
    if stat_type != nil and stat_subtype != nil
      StatisticTypeSubType.create!({statistic_type: stat_type, statistic_sub_type: stat_subtype})
    else
      puts 'ERROR: Unable to create the statistics association for the new rental. '+
           'Possible causes: the type or the subtype were not created successfully.'
    end
  end

  def update_stripe_rental
    old_stripe_rental = Stripe::Plan.retrieve(stp_rental_id)
    old_stripe_rental.delete
    create_stripe_rental
  end

  def delete_stripe_rental
    Stripe::Plan.retrieve(stp_rental_id).delete
  end


end
