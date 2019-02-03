class CreateCalls < ActiveRecord::Migration[5.2]
  def change
    create_table :calls do |t|
      t.timestamps
      t.integer :duration
      t.integer :user_id
      t.boolean :outbound

      t.timestamp :connected_at
      t.timestamp :hangup_at
      t.string :to
      t.string :from
      t.string :network_id
    end
    add_index :calls, :network_id, unique: true
  end
end
