class RenameItemColumnsForCurriculum < ActiveRecord::Migration[7.1]
  def change
    rename_column :items, :title,           :name
    rename_column :items, :description,     :info
    rename_column :items, :condition_id,    :sales_status_id
    rename_column :items, :shipping_fee_id, :shipping_fee_status_id
    rename_column :items, :shipping_day_id, :scheduled_delivery_id
  end
end