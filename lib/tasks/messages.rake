namespace :messages do
  desc "check twilio for new messages"
  task pull_twilio: :environment do
    client = Twilio::REST::Client.new ENV['ACC_SID'], ENV['ACC_TOK']
    client.api.account.messages.each do |msg|
      # [:subresource_uris, :uri, :delete, :account_sid, :to_s, :update, :date_created,
      #  :date_updated, :context, :direction, :fetch, :error_code, :feedback, :error_message,
      #  :inspect, :messaging_service_sid, :status, :date_sent, :price, :api_version, :num_media,
      #  :price_unit, :sid, :num_segments, :body, :media, :from, :to
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
