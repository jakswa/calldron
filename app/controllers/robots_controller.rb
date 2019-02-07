class RobotsController < ApplicationController
  def health_check
    render json: { healthy: true }
  end
end
