class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments_channel_#{ channel_id }"
  end
  
  private
    def channel_id
      "#{ params[:commentable_type] }_#{ commentable_id }" if params[:commentable_type]
    end
    
    def commentable_id
      params.fetch("#{params[:commentable_type].foreign_key}") if params[:commentable_type]
    end
end
