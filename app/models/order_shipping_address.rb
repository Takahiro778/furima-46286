class OrderShippingAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :token,
                :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number

  with_options presence: true do
    validates :postal_code,  format: { with: /\A\d{3}-\d{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" } # FURIMAは1が'--'
    validates :city
    validates :addresses
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid' }   # ハイフン無し
    validates :user_id
    validates :item_id
    validates :token
  end

  def save
    order = Order.create!(user_id: user_id, item_id: item_id)
    ShippingAddress.create!(
      postal_code: postal_code, prefecture_id: prefecture_id, city: city,
      addresses: addresses, building: building, phone_number: phone_number,
      order_id: order.id
    )
  end
end
