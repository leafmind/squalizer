class AddIndexOnSquareIdToLocations < ActiveRecord::Migration[5.0]
  def change
  	add_index :locations, :square_id, unique: true
  end
end
