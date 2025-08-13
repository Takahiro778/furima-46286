FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.initials(number: 2) }
    sequence(:email)      { |n| "test#{n}@example.com" }
    password              { '1a' + Faker::Internet.password(min_length: 6, mix_case: true) }
    password_confirmation { password }
    last_name             { '山田' }
    first_name            { '太郎' }
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'タロウ' }
    birth_date            { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
