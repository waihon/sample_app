FactoryGirl.define do
  # factory :user do
  #   name "Michael Hartl"
  #   email "mhartl@example.com"
  #   password "foobar"
  #   password_confirmation "foobar"
  #   remember_token "FTTfAyxmQGY6hf7W7owjYQ"
  # end
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
end