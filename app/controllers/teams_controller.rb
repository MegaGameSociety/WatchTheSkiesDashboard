class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_control!

  def index
    authenticate_admin!
    @teams = Team.all
  end

  # GET /team/1
  # GET /team/1.json
  def show
  end

  # GET /team/new
  def new
    @team = Team.new()
    @team_roles = TeamRole.all
    @games = Game.all
  end

  # GET /team/1/edit
  def edit
    @team_roles = TeamRole.all
  end

  # POST /user
  # POST /user.json
  def create
    @team = Team.new(team_params)
    respond_to do |format|
      if @team.save
       # current_game.users.push(@team)
        format.html { redirect_to teams_path, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team/1
  # PATCH/PUT /team/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to teams_path, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team/1
  # DELETE /team/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to team_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params[:team].permit(:team_name)
  end

end
