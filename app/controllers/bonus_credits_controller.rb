class BonusCreditsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_control!

  def index
    @bonus_credits = BonusCredit.all.order(:round, :team_name, :amount)
  end

  def new
    @round = current_game.round
    @countries = Game::COUNTRIES
    @bonus_credits = BonusCredit.new
  end

  def create
    @bonus_credits = BonusCredit.new(bonus_credit_params)

    respond_to do |format|
      if @bonus_credits.save
        current_game.bonus_credits << @bonus_credits
        format.html { redirect_to human_control_path, notice: 'Bonus Credits Successfully Applied'}
        format.json { render nothing: true, status: :created }
      else
        format.html { render :new }
        format.json { render json: @bonus_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bonus_credit = BonusCredit.find(params[:id])
    @bonus_credit.destroy
    respond_to do |format|
      format.html { redirect_to bonus_credits_path, notice: 'Bonus Credits Successfully Destroyed' }
      format.json { render nothing: true, status: :no_content }
    end
  end

  private

  def bonus_credit_params
    params.require(:bonus_credit).permit(:team_name, :round, :amount, :recurring)
  end
end
