class SetupJob < ApplicationJob
  SIP_DOMAIN_NAME = 'calldron sip domain'.freeze
  CRED_LIST_NAME = 'calldron credential list'.freeze

  include Rails.application.routes.url_helpers

  def perform(account_id, type = nil)
    @account_id = account_id

    case type
    when 'sip_domain' then setup_sip_domain
    when 'twiml_app' then setup_twiml_app
    else
      setup_twiml_app
      setup_sip_domain
    end
  end

  private

  def setup_twiml_app
  end

  def setup_sip_domain
    cred_list = credential_list # creates if does not exist

    sip_domain.credential_list_mappings.list.find do |mapping|
      mapping.sid == cred_list.sid
    end || sip_domain.credential_list_mappings.create(
      credential_list_sid: cred_list.sid
    )

    reg_mappings = sip_domain.auth.registrations.credential_list_mappings
    reg_mappings.list.find do |mapping|
      mapping.sid == cred_list.sid
    end || reg_mappings.create(
      credential_list_sid: cred_list.sid
    )
  end

  def sip_domain
    account.twilio_api.sip.domains.list.find do |domain|
      domain.friendly_name == SIP_DOMAIN_NAME
    end || create_sip_domain
  end

  def create_sip_domain
    account.twilio_api.sip.domains.create(
      domain_name: "#{Haikunator.haikunate}.sip.twilio.com",
      friendly_name: SIP_DOMAIN_NAME,
      voice_url: twilio_route_url,
      voice_status_callback_url: twilio_status_url,
      sip_registration: true,
    )
  end

  def credential_list
    account.twilio_api.sip.credential_lists.list.find do |creds|
      creds.friendly_name == CRED_LIST_NAME
    end || create_credential_list
  end

  def create_credential_list
    list = account.twilio_api.sip.credential_lists
      .create(friendly_name: CRED_LIST_NAME)
    
    username = credential_user.email.split('@').first
    password = SecureRandom.base64(12)
    credential_user.update(sip_password: password)
    list.credentials.create(username: username, password: password)

    list
  end

  def credential_user
    @credential_user ||= account.users.first!
  end

  def account
    @account ||= Account.find(@account_id)
  end
end
