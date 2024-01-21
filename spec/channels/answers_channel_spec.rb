require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question) }

  before do
    answer
  end

  it "subscribes to a stream with question's id" do
    subscribe
    perform('answers_follow', question_id: question.id)
    expect(subscription).to be_confirmed
    expect(subscription.streams).to include("answers_channel_#{question.id}")
  end
end
