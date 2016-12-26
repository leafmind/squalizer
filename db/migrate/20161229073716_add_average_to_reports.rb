class AddAverageToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :average, :text
  end
end
