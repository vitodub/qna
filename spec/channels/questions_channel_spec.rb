require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it "subscribes to a stream" do
    subscribe
    perform('questions_follow')
    expect(subscription).to be_confirmed
    expect(subscription.streams).to include("questions_channel")
  end
end
