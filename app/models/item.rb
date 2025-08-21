class Item < ApplicationRecord
  belongs_to :user
  has_one :order, dependent: :destroy
  has_one_attached :image

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :sales_status
  belongs_to :shipping_fee_status
  belongs_to :prefecture
  belongs_to :scheduled_delivery

  # --- エラーメッセージの表示順を固定 ---
  validates :image, presence: true              # 1
  validates :name,  presence: true              # 2
  validates :info,  presence: true              # 3

  validates :price, presence: true              # 4
  validates :price, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 300,
                                    less_than_or_equal_to: 9_999_999 } # 5

  with_options numericality: { other_than: 1, message: "can't be blank" } do
    validates :category_id            # 6
    validates :sales_status_id        # 7
    validates :shipping_fee_status_id # 8
    validates :prefecture_id          # 9
    validates :scheduled_delivery_id  # 10
  end
end
