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
  end
end
