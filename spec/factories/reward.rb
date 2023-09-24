FactoryBot.define do
  factory :reward do
    association :rewardable, factory: :question

    name { "BasicRewardNameString" }

    after(:build) do |reward|
      reward.file.attach(
        io: File.open("#{Rails.root}/app/assets/images/best_answer_reward.png"),
        filename: 'best_answer_reward.png',
        content_type: 'image/png'
      )
    end

    trait :another do
      name { "AnotherRewardNameString" }

      after(:build) do |reward|
        reward.file.attach(
          io: File.open("#{Rails.root}/app/assets/images/best_answer_reward_2.png"),
          filename: 'best_answer_reward_2.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
