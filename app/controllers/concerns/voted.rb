module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voted, only: %w[vote_yes vote_no cancel_vote]
  end

  def vote_yes
    current_user.vote_yes!(@voted) unless current_user.author_of?(@voted)
    
    render json: { rating: @voted.rating }
  end

  def vote_no
    current_user.vote_no!(@voted) unless current_user.author_of?(@voted)

    render json: { rating: @voted.rating }
  end

  def cancel_vote
    current_user.cancel_vote!(@voted) unless current_user.author_of?(@voted)

    render json: {rating: @voted.rating }
  end
  
  private
  
  def model_klass
    controller_name.classify.constantize
  end

  def set_voted
    @voted = model_klass.find(params[:id])
  end
end
