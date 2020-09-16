class CommentsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :authenticate_user!
  before_action :gon_user
  after_action :publish_comment, only: %w[create]

  authorize_resource
  
  def create
    @comment = current_user.comments.create(
      comment_params.merge(user: current_user, commentable_type: commentable_type, commentable_id: commentable_id)
    )

    if @comment.save
      render json: @comment.attributes.merge({ user_email: @comment.user.email, time_in_words: distance_of_time_in_words(Time.now, @comment.created_at) })
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def publish_comment
      return if @comment.errors.any?
      
      ActionCable.server.broadcast("comments_channel_#{ channel_id }", 
        @comment.attributes.merge({ 
          user_email: @comment.user.email, 
          time_in_words: distance_of_time_in_words(Time.now, @comment.created_at) 
        })
      )
    end

    def gon_user
      gon.user_id = current_user&.id 
    end

    def commentable_type
      params[:commentable_type].classify.constantize
    end

    def commentable_id
      params.fetch("#{params[:commentable_type].foreign_key}") 
    end

    def channel_id
      "#{ commentable_type.name.downcase }_#{ commentable_id }"
    end
end
