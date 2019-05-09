class AddForwardAllUntilToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :forward_all_until, :datetime
  end
end
