FactoryBot.define do
  factory :order_shipping_address do
    postal_code    { '123-4567' }
    prefecture_id  { 2 }                     # 1は'---'想定
    city           { '横浜市' }
    addresses      { '青山1-1-1' }
    building       { '柳ビル103' }          # 任意
    phone_number   { '09012345678' }
    token          { 'tok_abcdefghijk00000000000000000' }

    # 保存時に必要
    association :user
    association :item
  end
end
