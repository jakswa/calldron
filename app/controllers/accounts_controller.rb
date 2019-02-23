class AccountsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @account = current_user.account ||= Account.new
  end

  def update
    current_user.account ||= current_user.build_account
    current_user.account.update!(account_params)
    current_user.save! if current_user.changed?
    redirect_to edit_account_path, flash: { notice: 'Success!' }
  end

  private

  def account_params
    params.require(:account).permit(
      :twilio_token, :twilio_sid
    )
  end
end
