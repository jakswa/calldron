class AddUserToNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :numbers, :user_id, :integer
  end
end
