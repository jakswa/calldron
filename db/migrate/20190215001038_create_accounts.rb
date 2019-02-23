class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :twilio_sid
      t.string :twilio_token

      t.timestamps
    end
  end
end
