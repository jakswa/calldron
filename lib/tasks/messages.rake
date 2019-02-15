namespace :messages do
  desc "check twilio for new messages"
  task pull_twilio: :environment do
    ImportMessageJob.new.perform
  end
end
