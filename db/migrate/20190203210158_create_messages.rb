class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.timestamps
      t.integer :user_id
      t.boolean :outbound

      t.string :to
      t.string :from
      t.string :network_id
      t.string :content
    end

    add_index :messages, :network_id, unique: true
  end
end
