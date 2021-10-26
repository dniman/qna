class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :gon_user

  authorize_resource

  def create 
    current_user.subscribe!(@question) unless current_user.subscribed_to?(@question)
    
    render json: { question: @question, subscribed: current_user.subscribed_to?(@question) }
  end

  def destroy
    current_user.unsubscribe!(@question) if current_user.subscribed_to?(@question)

    render json: { question: @question, subscribed: current_user.subscribed_to?(@question) }
  end

  private
  
  def set_question
    @question = Question.find(params[:id])
  end

  def gon_user
    gon.user_id = current_user&.id
  end

end
