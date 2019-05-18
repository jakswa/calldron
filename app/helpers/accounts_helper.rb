module AccountsHelper

  def twilio_creds_valid?
    return @twilio_creds_valid if defined?(@twilio_creds_valid)
    @twilio_creds_valid = twiml_apps_returned?
  end

  def twiml_apps_returned?
    twiml_apps
    true
  rescue
    false
  end

  def app_name_for_sid(twiml_sid)
    twiml_apps.find { |twiml| twiml.sid == twiml_sid }&.friendly_name
  end

  def twiml_apps
    @twiml_apps ||= @account.twilio_api.applications.list
  end

  def numbers
    @numbers ||= @account.twilio_api.incoming_phone_numbers.list
  end

  def sip_addresses
    @account.twilio_api.sip.domains.list.flat_map do |domain|
      domain.auth.registrations.credential_list_mappings.list.flat_map do |clm|
        credential_mapping[clm.sid].credentials.list.map do |credential|
          "#{credential.username}@#{domain.domain_name}"
        end
      end
    end
  end

  def credential_mapping
    @cm ||= @account.twilio_api.sip.credential_lists
      .list.each_with_object({}) do |cred, obj|
        obj[cred.sid] = cred
      end
  end
end
