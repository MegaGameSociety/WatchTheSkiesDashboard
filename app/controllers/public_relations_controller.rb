class PublicRelationsController < ApplicationController
  before_action :set_public_relation, only: [:show, :edit, :update, :destroy]

  def un_dashboard
    @public_relations = PublicRelation.all.order(round: :desc, created_at: :desc)
    @countries = Game.countries()
    @current_round = Game.last.round

  end

  def create_un_dashboard
    data = params['un_public_relations']
    round = data['round']
    main_values_exist = (data['main_description'] != '' or data['main_pr_amount'] != '')
    results = []
    data['countries'].each do|country_name, country_data|
      if (!main_values_exist and country_data['description'] == '' and country_data['pr_amount'] == '')
        next
      end
      pr = PublicRelation.new
      pr.country = country_name
      pr.round = round
      if country_data['description'] == ''
        pr.description = data['main_description']
      else
        pr.description = country_data['description']
      end
      if country_data['description'] == ''
        pr.pr_amount = data['main_pr_amount']
      else
        pr.pr_amount = country_data['pr_amount']
      end
      pr.source = "UN"
      pr.save
      results.push(pr)
    end
    redirect_to un_dashboard_path
  end

  # GET /public_relations
  # GET /public_relations.json
  def index
    @public_relations = PublicRelation.all.order(round: :desc, created_at: :desc)
    @countries = Game.countries()
  end

  # GET /public_relations/1
  # GET /public_relations/1.json
  def show
  end

  # GET /public_relations/new
  def new
    @public_relation = PublicRelation.new
    @countries = Game.countries()
    @current_round = Game.last.round
  end

  # GET /public_relations/1/edit
  def edit
    @current_round = @public_relation.round
    @countries = Game.countries()
  end

  # POST /public_relations
  # POST /public_relations.json
  def create
    @public_relation = PublicRelation.new(public_relation_params)

    respond_to do |format|
      if @public_relation.save
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
    respond_to do |format|
      if @public_relation.update(public_relation_params)
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
      params[:public_relation].permit(:source, :country, :description, :round, :pr_amount)
    end

end
