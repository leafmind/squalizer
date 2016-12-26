class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :uid
      t.string :provider
      t.string :token

      t.index [:provider, :uid], unique: true
      t.index :provider 
      t.index :uid
      
      t.timestamps
    end
  end
end
