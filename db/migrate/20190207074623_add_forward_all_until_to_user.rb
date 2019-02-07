class AddForwardAllUntilToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :forward_all_until, :timestamp
  end
end
