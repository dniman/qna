class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answers_channel_#{ question_id }"
  end

  private
    def question_id
      params[:question_id]
    end
end
