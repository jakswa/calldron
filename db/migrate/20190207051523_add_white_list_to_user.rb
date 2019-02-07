class AddWhiteListToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :whitelist, :string, array: true
  end
end
