class PublicRelationsController < ApplicationController
  before_action :set_public_relation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_control!
  # Get
  def un_dashboard
    @public_relations = current_game.public_relations.all.order(round: :desc, created_at: :desc)
    @teams = Team.all_without_incomes
    @countries = Team.countries
    @current_round = current_game.round
  end

  # Post
  # Adds PR for un dashboard
  def create_un_dashboard
    data = params['un_public_relations']
    round = data['round']
    main_values_exist = (data['main_description'] != '' or data['main_pr_amount'] != '')
    results = []
    data['countries'].each do|team_name, country_data|
      if (!main_values_exist and country_data['description'] == '' and country_data['pr_amount'] == '')
        next
      end
      pr = PublicRelation.new
      pr.team = Team.find_by_team_name(team_name)
      pr.round = round
      if country_data['description'] == ''
        pr.description = data['main_description']
      else
        pr.description = country_data['description']
      end
      if country_data['pr_amount'] == ''
        pr.pr_amount = data['main_pr_amount']
      else
        pr.pr_amount = country_data['pr_amount']
      end

      if pr.pr_amount.nil?
        pr.pr_amount = 0
      end

      if pr.pr_amount >0
        pr.source = "UN Bonus"
      else
        pr.source = "UN Crisis"
      end
      pr.save
      results.push(pr)
    end
    current_game.public_relations.push(results)
    redirect_to un_dashboard_path
  end

  # Get
  def country_status
    @country = params[:country]
    @team = Team.where(team_name: @country)

    @teams = Team.all_without_incomes
    @game = current_game

    if @teams.any?{|x| x.team_name == @country}
      @public_relations = @game.public_relations.order(round: :desc, created_at: :desc).where(team: @team)
      # UN control needs to know amount of PR per group by type

      @pr_amounts = PublicRelation.country_status(@team, @game)
      @roundNum = (@game.round)
      @roundTotal = @game.public_relations.order(round: :desc, created_at: :desc).where(team: @team, round: @roundNum-1).sum(:pr_amount)

      @current_income = @game.incomes.where(team: @team, round: @roundNum)[0].amount
    else
      raise ActionController::RoutingError.new('Country Not Found')
    end
  end

  # GET /public_relations
  # GET /public_relations.json
  def index
    @public_relations = current_game.public_relations.order(round: :desc, created_at: :desc)
    @teams = Team.all_without_incomes
  end

  # GET /public_relations/1
  # GET /public_relations/1.json
  def show
  end

  # GET /public_relations/new
  def new
    @public_relation = PublicRelation.new
    @teams = Team.all_without_incomes
    @current_round = current_game.round
  end

  # GET /public_relations/1/edit
  def edit
    @current_round = @public_relation.round
    @teams = Team.all_without_incomes
  end

  # POST /public_relations
  # POST /public_relations.json
  def create
    teamId = public_relation_params['team'].to_i
    new_params = public_relation_params.except('team')
    @public_relation = PublicRelation.new(new_params)
    @public_relation.team = Team.find(teamId)

    respond_to do |format|
      if @public_relation.save
        current_game.public_relations.push(@public_relation)
        format.html { redirect_to @public_relation, notice: 'Public relation was successfully created.' }
        format.json { render :show, status: :created, location: @public_relation }
      else
        format.html { render :new }
        format.json { render json: @public_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /public_relations/1
  # PATCH/PUT /public_relations/1.json
  def update
    teamId = public_relation_params['team'].to_i
    new_params = public_relation_params.except('team')
    @public_relation.team = Team.find(teamId)

    respond_to do |format|
      if @public_relation.update(new_params)
        format.html { redirect_to @public_relation, notice: 'Public relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @public_relation }
      else
        format.html { render :edit }
        format.json { render json: @public_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /public_relations/1
  # DELETE /public_relations/1.json
  def destroy
    @public_relation.destroy
    respond_to do |format|
      format.html { redirect_to public_relations_url, notice: 'Public relation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_public_relation
      @public_relation = PublicRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def public_relation_params
      params[:public_relation].permit(:source, :country, :description, :round, :pr_amount, :team)
    end

end
