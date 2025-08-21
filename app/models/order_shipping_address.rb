class OrderShippingAddress
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city,
                :addresses, :building, :phone_number, :token

  # まず presence をまとめる（エラーメッセージの出る順も保てます）
  with_options presence: true do
    validates :token
    validates :postal_code
    validates :city
    validates :addresses
    validates :phone_number
    validates :user_id
    validates :item_id
  end

  # 形式・数値チェック等は allow_blank: true で重複防止
  validates :postal_code,
            format: { with: /\A\d{3}-\d{4}\z/,
                      message: 'is invalid. Enter it as follows (e.g. 123-4567)' },
            allow_blank: true

  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }

  # phone は「空→短い→数値以外→長い」の順で出す
  validates :phone_number, length: { minimum: 10, message: 'is too short' }, allow_blank: true
  validates :phone_number, format: { with: /\A\d+\z/, message: 'is invalid. Input only number' }, allow_blank: true
  validates :phone_number, length: { maximum: 11, message: 'is too long' }, allow_blank: true

  def save
    order = Order.create(user_id: user_id, item_id: item_id)
    ShippingAddress.create!(
      postal_code:    postal_code,
      prefecture_id:  prefecture_id,
      city:           city,
      addresses:      addresses,
      building:       building,
      phone_number:   phone_number,
      order_id:       order.id
    )
  end
end
