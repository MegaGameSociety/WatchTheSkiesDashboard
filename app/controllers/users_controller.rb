class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_control!

  def index
    authenticate_admin!
    @users = User.all
  end

  # GET /user/1
  # GET /user/1.json
  def show
  end

  # GET /user/new
  def new
    @user = User.new(role: "Player")
    @teams = Team.all
    @team_roles = TeamRole.all
    @games = Game.all
  end

  # GET /user/1/edit
  def edit
    @teams = Team.all
    @team_roles = TeamRole.all
  end

  # POST /user
  # POST /user.json
  def create
    teamId = user_params['team'].to_i
    teamRoleId = user_params['team_role'].to_i
    new_params = user_params.except('team', 'team_role', 'game')

    @user = User.new(new_params)
    @user.team = Team.find(teamId)
    @user.team_role = TeamRole.find(teamRoleId)
    @user.game = current_game
    @teams = Team.all
    @team_roles = TeamRole.all
    @games = Game.all

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user/1
  # PATCH/PUT /user/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user/1
  # DELETE /user/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to user_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user].permit(:role, :password, :password_confirmation, :email, :time_zone, :game, :team, :team_role)
  end

end
