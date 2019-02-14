Rails.application.routes.draw do
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'robots#health_check'
  get 'robots/health_check'
end
