module AccountsHelper

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
