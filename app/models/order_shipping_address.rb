# app/models/order_shipping_address.rb
class OrderShippingAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :token,
                :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number

  # --- ここからメッセージを見本に合わせて明示指定 ---
  validates :token,        presence: { message: "can't be blank" }

  validates :postal_code,  presence: { message: "can't be blank" }
  validates :postal_code,  format:   { with: /\A\d{3}-\d{4}\z/,
                                       message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
  # FURIMAは 1 が '---'。メッセージは "can't be blank" に固定
  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }

  validates :city,         presence: { message: "can't be blank" }
  validates :addresses,    presence: { message: "can't be blank" }

  validates :phone_number, presence: { message: "can't be blank" }
  # 「too short (minimum is ...)」ではなく、文言を固定
  validates :phone_number, length:  { minimum: 10, maximum: 11, message: "is too short" }
  validates :phone_number, format:  { with: /\A\d+\z/, message: "is invalid. Input only number" }
  # --- ここまで ---

  def save
    order = Order.create!(user_id: user_id, item_id: item_id)
    ShippingAddress.create!(
      postal_code: postal_code, prefecture_id: prefecture_id, city: city,
      addresses: addresses, building: building, phone_number: phone_number,
      order_id: order.id
    )
  end
end
