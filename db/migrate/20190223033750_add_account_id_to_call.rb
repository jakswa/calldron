class AddAccountIdToCall < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :account_id, :integer
  end
end
