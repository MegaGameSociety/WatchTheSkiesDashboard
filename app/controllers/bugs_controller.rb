class BugsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_control!

  def index
    @bugs = Bug.where(game: current_game).order(:created_at)
  end

  def new
    @bug = Bug.new
    @teams = Team.all
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.klass = Message
    @bug.game = current_game
    respond_to do |format|
      if @bug.save
        format.html { redirect_to bugs_path, notice: 'Bug Successfully Placed' }
        format.json {render nothing: true, status: :created}
      else
        format.html {render :new}
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @bug = Bug.find(params[:id])
    @bug.end_time = Time.now
    @bug.save
    respond_to do |format|
      format.html { redirect_to bugs_path, notice: "Bug Successfully " }
      format.json { render nothing: true, status: :accepted }
    end
  end

  def destroy
    @bug = Bug.find(params[:id])
    @bug.delete
    redirect_to bugs_path
  end

  private

  def bug_params
    params.require(:bug).permit(:game_id, :target, :beneficiary, :klass, :end_time)
  end
end
