class AnswersController < ApplicationController
  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @answer = Answer.new
  end
end
