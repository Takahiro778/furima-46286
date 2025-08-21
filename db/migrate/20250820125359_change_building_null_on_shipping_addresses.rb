class ChangeBuildingNullOnShippingAddresses < ActiveRecord::Migration[7.1]
  def up
    return unless table_exists?(:shipping_addresses) &&
                  column_exists?(:shipping_addresses, :building)

    change_column_null :shipping_addresses, :building, true
  end

  def down
    return unless table_exists?(:shipping_addresses) &&
                  column_exists?(:shipping_addresses, :building)

    change_column_null :shipping_addresses, :building, false
  end
end
