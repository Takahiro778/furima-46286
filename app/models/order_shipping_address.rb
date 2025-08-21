class OrderShippingAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id,
                :city, :addresses, :building, :phone_number, :token

  # 1) Token
  validates :token, presence: true

  # 2) Postal code（空→形式の順で出す）
  validates :postal_code, presence: true
  validates :postal_code,
            format: { with: /\A\d{3}-\d{4}\z/,
                      message: 'is invalid. Enter it as follows (e.g. 123-4567)' }

  # 3) Prefecture（--- を弾く）
  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }

  # 4) City
  validates :city, presence: true

  # 5) Addresses
  validates :addresses, presence: true

  # 6) Phone number（空→短い→数値以外→長い の順で出す）
  validates :phone_number, presence: true
  validates :phone_number, length: { minimum: 10, message: 'is too short' }
  validates :phone_number,
            format: { with: /\A\d+\z/, message: 'is invalid. Input only number' }
  validates :phone_number, length: { maximum: 11, message: 'is too long' }

  # 7) 紐づき
  validates :user_id, presence: true
  validates :item_id, presence: true

def save
  order = Order.create(user_id: user_id, item_id: item_id)
  ShippingAddress.create(
    postal_code:   postal_code,
    prefecture_id: prefecture_id,
    city:          city,
    addresses:     addresses,
    building:      building,
    phone_number:  phone_number,
    order_id:      order.id
  )
  end
end
