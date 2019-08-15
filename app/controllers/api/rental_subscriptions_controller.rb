class API::RentalSubscriptionsController < ApplicationController
	 include FablabConfiguration

  before_action :set_rental_subscription, only: [:show, :edit, :update, :cancel, :destroy]
  before_action :authenticate_user!

  def show
    authorize @subscription
  end

  def create
    if fablab_plans_deactivated?
      head 403
    else
      if current_user.is_admin?
        @subscription = RentalSubscription.find_or_initialize_by(user_id: rental_subscription_params[:user_id])
        @subscription.attributes = rental_subscription_params
        is_subscribe = @subscription.save_with_local_payment(true, coupon_params[:coupon_code])
      else
        @subscription = RentalSubscription.find_or_initialize_by(user_id: current_user.id)
        @subscription.attributes = rental_subscription_params
        is_subscribe = @subscription.save_with_payment(true, coupon_params[:coupon_code])
      end
      if is_subscribe
        render :show, status: :created, location: @subscription
      else
        render json: @subscription.errors, status: :unprocessable_entity
      end
    end
  end

  def update
    authorize @subscription

    free_days = params[:rental_subscription][:free] == true

    if @subscription.extend_expired_date(rental_subscription_update_params[:expired_at], free_days)
      ex_expired_at = @subscription.previous_changes[:expired_at].first
      @subscription.user.generate_admin_invoice(free_days, ex_expired_at)
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  def cancel

    @subscription.cancel
    
    render :show, status: :ok, location: @subscription
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_subscription_params
      params.require(:rental_subscription).permit(:rental_id, :user_id, :card_token)
    end

    def coupon_params
      params.permit(:coupon_code)
    end

    def rental_subscription_update_params
      params.require(:rental_subscription).permit(:expired_at)
    end

    # TODO refactor subscriptions logic and move this in model/validator
    def valid_card_token?(token)
      begin
        Stripe::Token.retrieve(token)
      rescue Stripe::InvalidRequestError => e
        @subscription.errors[:card_token] << e.message
        false
      end
    end
end
