class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.string :state
      t.references :user, index: true, foreign_key: true
      t.text :statistics
      t.timestamps
    end
  end
end
