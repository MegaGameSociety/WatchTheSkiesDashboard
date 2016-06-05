class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_control!

  # GET /incomes
  # GET /incomes.json
  def index
    @incomes = Income.all.order(created_at: :desc)
  end

  # GET /incomes/1
  # GET /incomes/1.json
  def show
  end

  # GET /incomes/new
  def new
    @round = current_game.round
    @teams = Team.all
    @income = Income.new
  end

  # GET /incomes/1/edit
  def edit
    @round = @income.round
    @teams = Team.all
  end

  # POST /incomes
  # POST /incomes.json
  def create
    teamId = income_params['team'].to_i
    new_params = income_params.except('team')
    @income = Income.new(new_params)
    @income.team = Team.find(teamId)
    @income.game = current_game.id

    respond_to do |format|
      if @income.save
        format.html { redirect_to @income, notice: 'Income was successfully created.' }
        format.json { render :show, status: :created, location: @income }
      else
        format.html { render :new }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incomes/1
  # PATCH/PUT /incomes/1.json
  def update
    teamId = income_params['team'].to_i
    new_params = income_params.except('team')
    @income.team = Team.find(teamId)

    respond_to do |format|
      if @income.update(new_params)
        format.html { redirect_to @income, notice: 'Income was successfully updated.' }
        format.json { render :show, status: :ok, location: @income }
      else
        format.html { render :edit }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incomes/1
  # DELETE /incomes/1.json
  def destroy
    @income.destroy
    respond_to do |format|
      format.html { redirect_to incomes_url, notice: 'Income was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income
      @income = Income.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_params
      params[:income].permit(:amount, :team, :round)
    end
end
