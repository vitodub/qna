FactoryBot.define do
  sequence :body do |n|
    "Answer №#{n}"
  end

  factory :answer do
    association :question
    association :user
    body

    trait :invalid do
      body { nil }
    end
    
    trait :with_gist_link do
      after(:build) do |answer|
        answer.links.new(name: 'gist link', url: 'https://gist.github.com/vitodub/5f67fadb25120be0220378d5e5dbfbeb')
      end
    end

    trait :best do
      best { true }
    end

    trait :secoond_best do
      best { true }
      body { "SecondBestAnswer" }
    end
  end
end
