Rails.application.routes.draw do
  resource :account

  get 'dashboard', to: 'dashboard#index'
  default_url_options host: ENV['APP_DOMAIN'], protocol: 'https'

  post 'twilio/route'
  post 'twilio/status'
  post 'twilio/outbound'
  post 'twilio/outbound_status'
  post 'twilio/recording'
  post 'twilio/transcribe'
  post 'twilio/sms'

  devise_for :users
  post 'message/:network_id/reply', to: 'messages#reply', as: 'message_reply'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  get 'robots/health_check'
end
