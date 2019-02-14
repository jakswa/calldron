class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @calls = Call.order(created_at: :desc).take(5)
    @messages = Message.order(created_at: :desc).take(5)
  end
end
