class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_set_up

  def index
    @calls = current_user.account.calls.order(created_at: :desc).take(5)
    @messages = current_user.account.messages.order(created_at: :desc).take(20)
  end

  private

  def ensure_set_up
    redirect_to(edit_account_path) unless current_user.account
  end
end
