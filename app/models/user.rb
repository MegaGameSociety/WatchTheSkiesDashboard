class User < ActiveRecord::Base
  CONTROL_ROLES = ["SuperAdmin","Admin","Control"]
  PLAYER_ROLES = ["Head of State", "Player"]
  belongs_to :game
  belongs_to :team
  belongs_to :team_role

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

  def self.file_import(file, game)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    users = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      next if row.values.all?{|x|x.nil?}
      user = User.find_or_create_by(email: row["E-mail"])

      if user.game.nil?
        user.game = game
      else
        next unless user.game == game
      end

      if row['Password'].present? and row['Password'] != ''
        user.password = row['Password']
        user.password_confirmation = row['Password']
      end

      user.team = Team.find_by_team_name(row['Team']) || user.team
      user.team_role = TeamRole.find_by_role_name(row['Role']) || user.team_role
      user.role = "Player"
      users << user
    end
    ActiveRecord::Base.transaction do
      users.each{|x| x.save }
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
