class AccountsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @account = current_user.account ||= Account.new
  end

  def update
    current_user.account ||= current_user.build_account
    current_user.account.assign_attributes(account_params)
    Account.transaction do
      current_user.account.save!
      current_user.save!
    end
    redirect_to edit_account_path, flash: { notice: 'Success!' }
  end

  private

  def account_params
    params.require(:account).permit(
      :twilio_token, :twilio_sid,
      :forward_all_until,
      whitelist: [],
    )
  end
end
