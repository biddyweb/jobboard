FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Johnny #{n}" }
    sequence(:email) { |n| "johnny_#{n}@example.com" }
    password "sampleton"
    password_confirmation "sampleton"

    factory :admin do
      admin true
    end
  end

  factory :job do
    sequence(:id) { |n| "#{n}" }
    sequence(:title) { |n| "Job #{n}" }
    org "Example"
    internship false
    postdate ""
    filldate ""
    location "Example"
    description ""
    link "http://www.example.com"
  end
end