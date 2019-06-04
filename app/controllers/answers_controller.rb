class AnswersController < ApplicationController
  before_action :find_question, only: %w[new create]
  before_action :set_answer, only: %w[show edit]

  def show
  end

  def new
    #@answer = Answer.new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    
    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
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
