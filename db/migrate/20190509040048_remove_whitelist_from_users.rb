class RemoveWhitelistFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :whitelist, :string, array: true
    remove_column :users, :forward_all_until, :datetime
  end
end
