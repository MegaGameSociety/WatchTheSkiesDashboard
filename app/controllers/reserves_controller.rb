class ReservesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_control!

  def index
    @reserves = Reserve.where(game: current_game).order(:round, :team_id, :amount)
  end

  def new
    @round = current_game.round
    @reserves = Reserve.new
    @teams = Team.all_minus_alien
  end

  def create
    teamId = bonus_credit_params['team'].to_i
    new_params = bonus_credit_params.except('team')
    @reserves = Reserve.new(new_params)
    @reserves.team = Team.find(teamId)
    @reserves.game = current_game

    respond_to do |format|
      if @reserves.save
        current_game.reserves << @reserves
        format.html { redirect_to human_control_path, notice: 'Reserves Successfully Applied'}
        format.json { render nothing: true, status: :created }
      else
        format.html { render :new }
        format.json { render json: @bonus_credit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bonus_credit = Reserve.find(params[:id])
    @bonus_credit.destroy
    respond_to do |format|
      format.html { redirect_to reserves_path, notice: 'Reserves Successfully Destroyed' }
      format.json { render nothing: true, status: :no_content }
    end
  end

  private

  def bonus_credit_params
    params.require(:bonus_credit).permit(:team, :round, :amount, :recurring)
  end
end
