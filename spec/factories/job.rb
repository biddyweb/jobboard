FactoryGirl.define do
  factory :job do
    sequence(:title) { |n| "Example Title #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    user
  end
end