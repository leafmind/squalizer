class AddSquareIdToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :square_id, :string
    add_index :transactions, [:location_id, :square_id], unique: true
  end
end
