class AddTranscriptionToCall < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :transcription, :text
  end
end
