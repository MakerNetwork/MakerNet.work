class RentalSubscription < ActiveRecord::Base
  include NotifyWith::NotificationAttachedObject

  belongs_to :rental
  belongs_to :user

  has_many :invoices, as: :invoiced, dependent: :destroy
  has_many :offer_days, dependent: :destroy 

  validates_presence_of :rental_id
  validates_with SubscriptionGroupValidator

 attr_accessor :card_token

   # creation
  after_save :notify_member_subscribed_rental_space, if: :is_new?
  after_save :notify_admin_subscribed_rental_space, if: :is_new?
  after_save :notify_partner_subscribed_rental_space, if: :of_partner_plan?


 private
  def notify_member_subscribed_rental_space
    NotificationCenter.call type: 'notify_member_subscribed_rental_space',
                            receiver: user,
                            attached_object: self
  end

  def notify_admin_subscribed_rental_space
    NotificationCenter.call type: 'notify_admin_subscribed_rental_space',
                            receiver: User.admins,
                            attached_object: self
  end

  def notify_admin_rental_space_subscription_canceled
    NotificationCenter.call type: 'notify_admin_rental_space_subscription_canceled',
                            receiver: User.admins,
                            attached_object: self
  end

  def notify_member_rental_space_subscription_canceled
    NotificationCenter.call type: 'notify_member_rental_space_subscription_canceled',
                            receiver: user,
                            attached_object: self
  end

  def notify_partner_subscribed_rental_space
    NotificationCenter.call type: 'notify_partner_subscribed_rental_space',
                            receiver: plan.partners,
                            attached_object: self
  end

  def notify_rental_space_subscription_extended(free_days)
    meta_data = {}
    meta_data[:free_days] = true if free_days == true
    notification = Notification.new(meta_data: meta_data)
    notification.send_notification(type: :notify_member_rental_space_subscription_extended, attached_object: self).to(user).deliver_later

    User.admins.each do |admin|
      notification = Notification.new(meta_data: meta_data)
      notification.send_notification(type: :notify_admin_rental_space_subscription_extended, attached_object: self).to(admin).deliver_later
  	end
  end

  # set a expired date by plan
  # expired_at will be updated when has a new payment
  def set_expired_at
    start_at = Time.now
    self.expired_at = start_at + rental.duration
  end

  def expired_date_changed
    p_value = self.previous_changes[:expired_at][0]
    return true if p_value.nil?
    p_value.to_date != expired_at.to_date and expired_at > p_value
  end

  def is_new?
    expired_at_was.nil?
  end
  
  #def of_partner_plan?
  #  space.is_a?(PartnerPlan)
  #end

  def get_wallet_amount_debit
    total = rental.amount
    if @coupon
      total = CouponService.new.apply(total, @coupon, user.id)
    end
    wallet_amount = (user.wallet.amount * 100).to_i
    return wallet_amount >= total ? total : wallet_amount
  end

  def debit_user_wallet
    if @wallet_amount_debit.present? and @wallet_amount_debit != 0
      amount = @wallet_amount_debit / 100.0
      return WalletService.new(user: user, wallet: user.wallet).debit(amount, self)
    end
  end

  def clear_wallet_and_goupon_invoice_items(invoice_items)
    begin
      invoice_items.each(&:delete)
    rescue Stripe::InvalidRequestError => e
      logger.error e
    rescue Stripe::AuthenticationError => e
      logger.error e
    rescue Stripe::APIConnectionError => e
      logger.error e
    rescue Stripe::StripeError => e
      logger.error e
    rescue => e
      logger.error e
    end
  end
end
