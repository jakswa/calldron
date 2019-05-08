class Message < ApplicationRecord
  belongs_to :account

  def contact_number
    outbound? ? to : from
  end

  # you can 'reply' to any message, so to/from decision is awkward
  def reply(new_content)
    child = self.class.new(
      account: account,
      from: outbound? ? from : to,
      to: outbound? ? to : from,
      outbound: true,
      content: new_content
    )
    child.send!
    child.save!
    child
  end

  def send!
    response = account.twilio_api.messages.create(
      body: content,
      from: from,
      to: to
    )
    self.network_id = response.sid
  end
end
