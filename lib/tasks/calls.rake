namespace :calls do
  desc "pull calls from twilio"
  task pull_twilio: :environment do
    client = Twilio::REST::Client.new ENV['ACC_SID'], ENV['ACC_TOK']
    client.api.account.calls.each do |call|
      # [:subresource_uris, :uri, :delete, :account_sid, :to_s, :update, :date_created,
      #  :date_updated, :context, :direction, :fetch, :error_code, :feedback, :error_message,
      #  :inspect, :messaging_service_sid, :status, :date_sent, :price, :api_version, :num_media,
      #  :price_unit, :sid, :num_segments, :body, :media, :from, :to
      Call.where(network_id: call.sid).first_or_create(
        created_at: call.date_created,
        to: call.to,
        from: call.from,
        outbound: call.direction == 'outbound-api',
        duration: call.duration,
      )
    end
  end

end
