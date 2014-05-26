FactoryGirl.define do
  factory :job do
    sequence(:title) { |n| "Example Title #{n}" }
    user
  end
end