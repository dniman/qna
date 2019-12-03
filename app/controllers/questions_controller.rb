class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %w[index show]
  before_action :set_question, only: %w[show update destroy]

  def index
    @questions = Question.all

    if user_signed_in?
      @question = current_user.questions.new
      @question.links.build
    end
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = current_user.questions.create(question_params)
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
   
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
      
    respond_to do |format|
      format.js
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                     files: [], links_attributes: [:name, :url])
  end
end
