class Income < ActiveRecord::Base
  belongs_to :game
  belongs_to :team

  def team_name
    self.team.team_name
  end

  def credits
    income_to_credit = get_income_to_credits_array
    safe_get_credits_value(income_to_credit)
  end

  private
  def get_income_to_credits_array
    case self.team_name
      when 'China'
        [2, 3, 5, 7, 9, 10, 12, 14, 16]
      when 'Japan'
        [3, 5, 6, 8, 9, 10, 12, 13, 14]
      when 'Russian Federation'
        [2, 4, 5, 6, 7, 8, 9, 10, 11]
      when 'United Kingdom'
        [2, 4, 6, 7, 8, 9, 10, 11, 12]
      when 'USA'
        [1, 3, 5, 7, 9, 11, 13, 15, 17]
      when 'Germany'
        [2, 5, 6, 7, 8, 9, 10, 12, 14]
      else
        [2, 5, 6, 7, 8, 9, 10, 11, 12]
    end
  end

  def safe_get_credits_value(income_to_credit)
    if self.amount > income_to_credit.length
      income_to_credit[income_to_credit.length - 1]
    elsif self.amount < 1
      0
    else
      income_to_credit[self.amount - 1]
    end
  end

end
