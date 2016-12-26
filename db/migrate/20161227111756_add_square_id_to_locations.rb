class AddSquareIdToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :square_id, :string
  end
end
