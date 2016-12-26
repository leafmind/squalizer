class AddAmountAndCurrencyToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :amount, :integer
    add_column :transactions, :currency, :string
  end
end
