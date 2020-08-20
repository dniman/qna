class AnswersController < ApplicationController
  #include Rails.application.routes.url_helpers
  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: %w[create]
  before_action :set_answer, only: %w[update destroy mark_as_the_best]
  before_action :gon_user
  after_action :publish_answer, only: %w[create]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
    @comment = Comment.new

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
    @comment = Comment.new
    
    respond_to do |format|
      format.js 
    end
  end

  private

    def find_question
      @question = Question.with_attached_files.find(params[:question_id])
    end

    def set_answer
      @answer = Answer.with_attached_files.find(params[:id])
      gon.answer_id = @answer.id
    end

    def answer_params
      params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
    end
    
    def publish_answer
      return if @answer.errors.any?

      ActionCable.server.broadcast 'answers', { 
        answer: @answer, 
        question: @answer.question,
        attachments: @answer.files.attachments.inject([]) { |arr, a| arr << { id: a.id, url: rails_blob_url(a), filename: a.blob.filename, user_id: a.record.user_id } },
        links: @answer.links.inject([]) { |arr, l| arr << { id: l.id, name: l.name, url: l.url, linkable_type: l.linkable_type, linkable_id: l.linkable_id, user_id: @answer.user_id} },
        comment: @answer.comments.new
      }
    end

    def gon_user
      gon.user_id = current_user&.id 
    end
end
