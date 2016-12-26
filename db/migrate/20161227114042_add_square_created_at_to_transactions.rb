class AddSquareCreatedAtToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :square_created_at, :datetime, null: false
  end
end
