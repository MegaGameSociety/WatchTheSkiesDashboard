class BonusReservesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_control!

  def index
    @bonus_reserves = BonusReserve.where(game: current_game).order(:round, :team_id, :amount)
  end

  def new
    @round = current_game.round
    @bonus_reserves = BonusReserve.new
    @teams = Team.all_without_incomes
  end

  def create
    teamId = bonus_reserve_params['team'].to_i
    new_params = bonus_reserve_params.except('team')
    @bonus_reserves = BonusReserve.new(new_params)
    @bonus_reserves.team = Team.find(teamId)
    @bonus_reserves.game = current_game

    respond_to do |format|
      if @bonus_reserves.save
        current_game.bonus_reserves << @bonus_reserves
        format.html { redirect_to human_control_path, notice: 'Bonus Credits Successfully Applied'}
        format.json { render nothing: true, status: :created }
      else
        format.html { render :new }
        format.json { render json: @bonus_reserve.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bonus_reserve = BonusReserve.find(params[:id])
    @bonus_reserve.destroy
    respond_to do |format|
      format.html { redirect_to bonus_reserves_path, notice: 'Bonus Credits Successfully Destroyed' }
      format.json { render nothing: true, status: :no_content }
    end
  end

  private

  def bonus_reserve_params
    params.require(:bonus_reserve).permit(:team, :round, :amount, :recurring)
  end
end
