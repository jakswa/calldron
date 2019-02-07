class AddCallerIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :caller_id, :string
  end
end
