class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %w[create]
  before_action :set_answer, only: %w[update destroy mark_as_the_best]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    @question = @answer.question
    
    respond_to do |format|
      format.js
    end
  end

  def mark_as_the_best
    @question = @answer.question
    @answer.mark_as_the_best_answer! if current_user.author_of?(@question)
    
    respond_to do |format|
      format.js 
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
