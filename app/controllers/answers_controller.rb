class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_question, only: %w[new create]
  before_action :set_answer, only: %w[show edit update destroy]

  def show
  end

  def new
    @answer = @question.answers.new.tap { |a| a.user = current_user }
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params).tap { |a| a.user = current_user }
    
    if @answer.save
      redirect_to answer_path(@answer), notice: 'Your answer was successfully created.'
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
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
