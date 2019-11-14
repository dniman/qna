class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_question, only: %w[new create]
  before_action :set_answer, only: %w[show edit update destroy mark_as_the_best]

  def show
  end

  def new
    @answer = @question.answers.new.tap { |a| a.user = current_user }
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params).tap { |a| a.user = current_user }
    @answer.save
    
    respond_to do |format|
      format.js {}
      format.html { redirect_to question_path(@question) }
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question

    respond_to do |format|
      format.js {}
      format.html { redirect_to question_path(@question) }
    end
  end

  def destroy
    @answer.destroy
    @question = @answer.question
    
    respond_to do |format|
      format.js {}
      format.html { redirect_to question_path(@question) }
    end
  end

  def mark_as_the_best
    @answer.mark_as_the_best
    @question = @answer.question

    respond_to do |format|
      format.js {}
      format.html { redirect_to question_path(@question) }
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
    params.require(:answer).permit(:body)
  end
end
