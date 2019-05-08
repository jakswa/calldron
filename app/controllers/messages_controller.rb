class MessagesController < ApplicationController
  before_action :authenticate_user!

  def reply
    @message = Message.find_by!(network_id: params.require(:network_id))
    new_message = @message.reply(params.require(:content))
    redirect_to request.referrer
  end
end
