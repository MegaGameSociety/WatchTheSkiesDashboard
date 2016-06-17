class Api::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_control!

  def messages
    @team = Team.find(params[:team_id])
    @messages = Message.where(game: current_game).where('sender_id = ? OR recipient_id = ?', @team.id, @team.id)

    begin
      #generate overall embedded result
      @result = {
        "messages" => @messages,
        "new_message" => Message.new
      }
    rescue
      @status = 500
      @message = "Failure to generate message results."
    end

    # if we haven't set a message, we sucessfully made stuff
    unless @message
      @status = 200
      @message = "Success!"
    end

    @response = {
      status: @status,
      message: @message,
      date:  Time.now,
      result: @result
    }

    respond_to do |format|
      format.json { render :json => @response }
    end
  end
end
