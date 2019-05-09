class ImportJob < ApplicationJob
  def perform(account_id, type = nil)
    @account_id = account_id
    case type
    when 'calls' then import_calls
    when 'sms' then import_sms
    when 'numbers' then import_numbers
    else
      import_calls
      import_sms
      import_numbers
    end
  end

  def import_numbers
    account.twilio_api.incoming_phone_numbers.each do |number|
      account.numbers.where(network_id: number.sid).first_or_create!(
        number: number.phone_number.slice(1..-1),
        user: default_user
      )
    end
  end

  def import_sms
    account.twilio_api.messages.each do |msg|
      Message.where(network_id: msg.sid).first_or_create(
        account_id: @account_id,
        created_at: msg.date_created,
        to: msg.to,
        from: msg.from,
        outbound: msg.direction == 'outbound-api',
        content: msg.body,
      )
    end
  end

  def import_calls
    account.twilio_api.calls.each do |call|
      # [:subresource_uris, :uri, :delete, :account_sid, :to_s, :update, :date_created,
      #  :date_updated, :context, :direction, :fetch, :error_code, :feedback, :error_message,
      #  :inspect, :messaging_service_sid, :status, :date_sent, :price, :api_version, :num_media,
      #  :price_unit, :sid, :num_segments, :body, :media, :from, :to
      Call.where(network_id: call.sid).first_or_create(
        account_id: @account_id,
        created_at: call.date_created,
        to: call.to,
        from: call.from,
        outbound: call.direction == 'outbound-api',
        duration: call.duration,
      )
    end
  end

  private

  def default_user
    @default_user ||= account.users.first!
  end

  def account
    @account ||= Account.find(@account_id)
  end
end
