class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed  :registerable to prevent registration
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
