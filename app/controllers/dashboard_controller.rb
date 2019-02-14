class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @calls = Call.order(created_at: :desc).last(10)
    @messages = Message.order(created_at: :desc).last(20)
  end
end
