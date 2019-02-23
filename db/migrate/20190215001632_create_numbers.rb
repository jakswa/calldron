class CreateNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :numbers do |t|
      t.integer :account_id
      t.string :network_id
      t.string :number

      t.timestamps
    end
  end
end
