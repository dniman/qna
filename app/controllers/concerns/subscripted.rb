module Subscripted
  extend ActiveSupport::Concern

  included do
    before_action :set_subscripted, only: %w[subscribe unsubscribe]
  end

  def subscribe
    current_user.subscribe!(@subscribed) unless current_user.subscribed_to?(@subscribed)
    
    render json: { subscriptionable: @subscribed, subscribed: current_user.subscribed_to?(@subscribed) }
  end

  def unsubscribe
    current_user.unsubscribe!(@subscribed) if current_user.subscribed_to?(@subscribed)

    render json: { subscriptionable: @subscribed, subscribed: current_user.subscribed_to?(@subscribed) }
  end

  private
  
  def model_klass
    controller_name.classify.constantize
  end

  def set_subscripted
    @subscribed = model_klass.find(params[:id])
  end
end
