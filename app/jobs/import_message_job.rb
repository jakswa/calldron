class ImportMessageJob < ApplicationJob
  def perform
    client = Twilio::REST::Client.new ENV['ACC_SID'], ENV['ACC_TOK']
    client.api.account.messages.each do |msg|
      Message.where(network_id: msg.sid).first_or_create(
        created_at: msg.date_created,
        to: msg.to,
        from: msg.from,
        outbound: msg.direction == 'outbound-api',
        content: msg.body,
      )
    end
  end
end
