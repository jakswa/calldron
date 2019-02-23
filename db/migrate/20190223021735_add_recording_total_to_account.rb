class AddRecordingTotalToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :recording_total, :integer
  end
end
