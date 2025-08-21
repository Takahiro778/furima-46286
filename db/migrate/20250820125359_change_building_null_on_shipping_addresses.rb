class ChangeBuildingNullOnShippingAddresses < ActiveRecord::Migration[7.1]
  def change
    change_column_null :shipping_addresses, :building, true
  end
end
