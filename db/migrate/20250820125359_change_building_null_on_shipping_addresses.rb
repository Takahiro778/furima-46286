class ChangeBuildingNullOnAddresses < ActiveRecord::Migration[7.1]
  def change
    change_column_null :addresses, :building, true
  end
end
