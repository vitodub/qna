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

    trait :with_attached_file do
      after(:build) do |question|
        question.files.attach(
          io: File.open("#{Rails.root}/spec/files/file1.txt"),
          filename: 'file1.txt',
          content_type: 'text/txt'
        )
      end
    end
  end
end
