FactoryBot.define do
  sequence :title do |n|
    "Question №#{n}"
  end

  factory :question do
    association :user
    title
    body { "Question body" }

    trait :invalid do 
      title { nil }
    end

    trait :with_gist_link do
      after(:build) do |question|
        question.links.new(name: 'gist link', url: 'https://gist.github.com/vitodub/5f67fadb25120be0220378d5e5dbfbeb')
      end
    end

    trait :with_reward do
      reward_name { "BestAnswer" }
      after(:build) do |question|
          question.reward.attach(
          io: File.open("#{Rails.root}/app/assets/images/best_answer_reward.png"),
          filename: 'best_answer_reward.png',
          content_type: 'image/png'
        )
      end  
    end  
  end
end
