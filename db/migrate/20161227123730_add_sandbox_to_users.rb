class AddSandboxToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :sandbox, :boolean, default: false
  end
end
