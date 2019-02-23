class AddWhitelistToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :whitelist, :string, array: true
  end
end
