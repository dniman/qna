class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from "questions_channel"
  end
end
