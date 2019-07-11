class WebhooksController < ApplicationController

  protect_from_forgery :except => :stripe

  def create
    ##data_json = JSON.parse request.body.read

    render nothing: true  
  end

  def stripe
    endpoint_secret = Rails.application.secrets.stripe_signing_secret
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
        event = Stripe::Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
    rescue JSON::ParserError => e
        # Invalid payload
        status 400
        return
    rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        status 400
        return
    end

    # Handle the event
    case event.type
    when 'invoice.payment_succeeded'
      subscription = Subscription.find_by_stp_subscription_id(event.data.object.subscription)
      if subscription and subscription.is_expired?
        subscription.renew(subscription.plan.interval)
      end
      ##TODO add similar behavoir for rentals here
    else
      # Unexpected event type
      status 400
      return
    end

    render status: 200, nothing: true  
  end
end
