class User < ActiveRecord::Base
  CONTROL_ROLES = ["SuperAdmin","Admin","Control"]
  PLAYER_ROLES = ["Head of State"]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed  :registerable to prevent registration
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def super_admin?
    return self.role == "SuperAdmin"
  end

  def admin?
    return self.role == "Admin" || self.role == "SuperAdmin"
  end

  def control?
    CONTROL_ROLES.include?(self.role)
  end

  def managed_roles
    if self.super_admin?
      CONTROL_ROLES + PLAYER_ROLES
    elsif self.admin?
      PLAYER_ROLES + ["Control"]
    elsif self.role == "Control?"
      PLAYER_ROLES + "Control"
    else
      nil
    end
  end
end
