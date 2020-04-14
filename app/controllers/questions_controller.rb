class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %w[index show]
  before_action :set_question, only: %w[show update destroy]
  before_action :gon_user
  after_action :publish_question, only: %w[create]

  def index
    @questions = Question.all

    if user_signed_in?
      @question = current_user.questions.new
      @question.links.build
      @question.build_bounty
    end
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = current_user.questions.create(question_params)

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
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
      gon.question_id = @question.id
    end

    def question_params
      params.require(:question).permit(:title, :body, files: [], 
                                     links_attributes: [:name, :url],
                                     bounty_attributes: [:name, :image])
    end

    def publish_question
      return if @question.errors.any?

      ActionCable.server.broadcast 'questions', @question
    end

    def gon_user
      gon.user_id = current_user&.id 
    end
end
