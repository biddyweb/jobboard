  FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Johnny #{n}" }
    sequence(:email) { |n| "johnny_#{n}@example.com" }
    password "sampleton"
    password_confirmation "sampleton"
  end

  factory :job do
    sequence(:title) { |n| "Example Title #{n}" }
    user
  end
end