class Message < ActiveRecord::Base
  belongs_to :game
  belongs_to :sender, class_name: 'Team'
  belongs_to :recipient, class_name: 'Team'

  class << self
    def set_visible
      self.update_all(visible: true)
    end
  end
end
