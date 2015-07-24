class TerrorTrackersController < ApplicationController
  before_action :set_terror_tracker, only: [:show, :edit, :update, :destroy]

  # GET /terror_trackers
  # GET /terror_trackers.json
  def index
    @terror_trackers = TerrorTracker.all
  end

  # GET /terror_trackers/1
  # GET /terror_trackers/1.json
  def show
  end

  # GET /terror_trackers/new
  def new
    @terror_tracker = TerrorTracker.new
  end

  # GET /terror_trackers/1/edit
  def edit
  end

  # POST /terror_trackers
  # POST /terror_trackers.json
  def create
    @terror_tracker = TerrorTracker.new(terror_tracker_params)

    respond_to do |format|
      if @terror_tracker.save
        format.html { redirect_to @terror_tracker, notice: 'Terror tracker was successfully created.' }
        format.json { render :show, status: :created, location: @terror_tracker }
      else
        format.html { render :new }
        format.json { render json: @terror_tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /terror_trackers/1
  # PATCH/PUT /terror_trackers/1.json
  def update
    respond_to do |format|
      if @terror_tracker.update(terror_tracker_params)
        format.html { redirect_to @terror_tracker, notice: 'Terror tracker was successfully updated.' }
        format.json { render :show, status: :ok, location: @terror_tracker }
      else
        format.html { render :edit }
        format.json { render json: @terror_tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terror_trackers/1
  # DELETE /terror_trackers/1.json
  def destroy
    @terror_tracker.destroy
    respond_to do |format|
      format.html { redirect_to terror_trackers_url, notice: 'Terror tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terror_tracker
      @terror_tracker = TerrorTracker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def terror_tracker_params
      params[:terror_tracker]
    end
end
