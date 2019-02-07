class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def whitelisted?(from)
    whitelist_disabled? ||
      whitelist&.include?(from)
  end

  def whitelist_disabled?
    forward_all_until &&
      forward_all_until > Time.current 
  end
end
