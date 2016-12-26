class AddIdempotencyKeyToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :idempotency_key, :string
    add_index :transactions, :idempotency_key, unique: true
  end
end
