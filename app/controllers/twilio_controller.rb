class TwilioController < ApplicationController
  skip_forgery_protection

  def route
    if params[:CallStatus] == 'ringing'
      handle_new_call
    elsif %w[no-answer busy failed].include?(params[:DialCallStatus])
      record_voicemail
    end
    render xml: xml_response
  end

  def status
    finalize_call if params.key?(:CallDuration)
    head 201
  end

  def outbound
    return caller_id_feedback unless outbound_caller_id
    xml.Dial(
      strip(params[:To]),
      callerId: outbound_caller_id,
      answerOnBridge: true
    )
    render xml: xml_response
  end

  def outbound_status
    finalize_call(outbound: true) if params.key?(:CallDuration)
    head 201
  end

  def recording
    head 201
  end

  def transcribe
    head 201
  end

  def sms
    account.messages.where(network_id: params[:MessageSid]).first_or_create!(
      to: strip(params[:To]),
      from: strip(params[:From]),
      content: params[:Body]
    )
    head 201
  end

  private

  def strip(param)
    case param
    when /^sip:/ then param.split(/[:@]/)[1]
    else param.gsub(/\D/, '') 
    end
  end

  def handle_new_call
    if account.whitelisted?(params[:From])
      dial_sip_user
    else
      xml.Reject
    end
  end

  # really the only thing unique here is that we'll have duration set
  def finalize_call(outbound: nil)
    account.calls.where(network_id: params[:CallSid]).first_or_create!(
      to: strip(params[:To]),
      from: strip(params[:From]),
      outbound: outbound,
      duration: params[:CallDuration]
    )
  end

  def dial_sip_user
    xml.Dial(answerOnBridge: true, action: 'route') do
      xml.Sip(sip_user_address)
    end
  end

  def record_voicemail
    xml.Say('Leave a voicemail after the tone.')
    xml.Record(
      maxLength: 60,
      transcribeCallback: 'transcribe',
      recordingStatusCallback: 'recording'
    )
  end

  def sip_user_address
    sip_user = inbound_user.email.split('@').first
    "sip:#{sip_user}@#{ENV['TWILIO_SIP_DOMAIN']}"
  end

  def xml_response
    wrapper = Builder::XmlMarkup.new
    wrapper.instruct!
    wrapper.Response do
      wrapper << xml.target!
    end
    wrapper.target!
  end

  def outbound_user
    return @outbound_user if defined?(@outbound_user)
    from_user = params[:From].split(/[:@]/)[1]
    @outbound_user = account.users
      .where("email LIKE ?", "#{from_user}%").first!
  end

  def outbound_caller_id
    outbound_user.caller_id ||
      account.numbers.find_by(user_id: outbound_user.id)&.number
  end

  def caller_id_feedback
    xml.Say("You must set your caller ID before dialing outbound. Goodbye.")
    xml.Hangup
    render xml: xml_response
  end

  def inbound_number
    @inbound_number ||= Number.find_by!(number: params[:To])
  end

  def inbound_user
    @user ||= inbound_number.user
  end

  def account
    @account ||= Account.find_by(twilio_sid: params.require(:AccountSid))
  end

  def xml
    @xml ||= Builder::XmlMarkup.new
  end
end
