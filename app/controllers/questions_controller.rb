class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:update, :destroy]

  def index
    @questions = Question.all.includes(:user)
    @question = current_user.questions.new if user_signed_in?
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.new
  end

  def create
    @question = current_user.questions.create(question_params)
    
    respond_to do |format|
      format.js {}
      format.html { redirect_to questions_path }
    end
  end

  def update
    return unless @question

    @question.update(question_params)
    
    respond_to do |format|
      format.js {}
      format.html { redirect_to questions_path }
    end
  end

  def destroy
    return unless @question

    @question.destroy

    respond_to do |format|
      format.js {}
      format.html { redirect_to questions_path }
    end
  end

  private

  def set_question
    question = Question.find(params[:id])
    @question = question if current_user.author_of?(question)
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
