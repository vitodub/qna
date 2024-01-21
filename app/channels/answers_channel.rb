class AnswersChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def answers_follow(data)
    stream_from "answers_channel_#{data['question_id']}"
  end
end
