class Income < ActiveRecord::Base
  belongs_to :game
  belongs_to :team

  COUNTRY_CREDIT_LEVELS = {
      'Brazil' =>
          [2, 5, 6, 7, 8, 9, 10, 11, 12],
      'China' =>
          [2, 3, 5, 7, 9, 10, 12, 14, 16],
      'France' =>
          [2, 5, 6, 7, 8, 9, 10, 11, 12],
      'India' =>
          [2, 5, 6, 7, 8, 9, 10, 11, 12],
      'Japan' =>
          [3, 5, 6, 8, 9, 10, 12, 13, 14],
      'Russian Federation' =>
          [2, 4, 5, 6, 7, 8, 9, 10, 11],
      'United Kingdom' =>
          [2, 4, 6, 7, 8, 9, 10, 11, 12],
      'USA' =>
          [1, 3, 5, 7, 9, 11, 13, 15, 17],
      'Germany' =>
          [2, 5, 6, 7, 8, 9, 10, 12, 14]
  }
  COUNTRY_CREDIT_LEVELS.default = [2, 5, 6, 7, 8, 9, 10, 11, 12]

  def team_name
    self.team.team_name
  end

  def credits
    income_to_credit = COUNTRY_CREDIT_LEVELS[self.team_name]
    safe_get_credits_value(income_to_credit)
  end

  private
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
