class Account < ApplicationRecord
  has_many :users
  has_many :numbers
  has_many :calls
  has_many :messages

  after_commit(on: :create) { ImportJob.perform_later(id) }

  def whitelisted?(from)
    whitelist_disabled? ||
      whitelist&.include?(from)
  end

  def whitelist_disabled?
    forward_all_until &&
      forward_all_until > Time.current
  end

  def twilio_api
    twilio_client.api.account
  end

  def twilio_client
    @client ||= Twilio::REST::Client.new(twilio_sid, twilio_token)
  end
end
