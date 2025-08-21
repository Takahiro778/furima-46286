class ShippingAddress < ApplicationRecord
  belongs_to :order
  # validates :building, presence: true ← 付けない
end
