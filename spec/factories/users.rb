FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'apis@rails.com' }
    password { 'wairimu' }
  end
end

