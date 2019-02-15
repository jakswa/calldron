namespace :calls do
  desc "pull calls from twilio"
  task pull_twilio: :environment do
    ImportCallJob.new.perform
  end
end
