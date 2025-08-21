FactoryBot.define do
  factory :item do
    user

    name  { 'テスト商品' }
    info  { '説明テキスト' }

    category_id            { 2 }
    sales_status_id        { 2 }
    shipping_fee_status_id { 2 }
    prefecture_id          { 2 }
    scheduled_delivery_id  { 2 }

    price { 1000 }

    after(:build) do |item|
      item.image.attach(
        io: Rails.root.join('spec/fixtures/files/test.png').open,
        filename: 'test.png', content_type: 'image/png'
      )
    end
  end
end
