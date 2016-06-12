class Api::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @game = params[:game_id].nil? ? current_game : Game.find_by_id(params[:game_id])
    @game.update

    recipientId = message_params['recipient'].to_i
    senderId = message_params['sender'].to_i

    new_params = message_params.except('recipient', 'sender')
    @message = Message.new(new_params)
    @message.sender = Team.find(senderId)
    @message.recipient = Team.find(recipientId)

    @message.round_number = @game.round
    @message.game_id = @game.id
    @message.updated_at = Time.now.to_i;

    @message.save
    render json: @message
  end

  private
    def message_params
      params.require(:message).permit(:sender, :recipient, :content)
    end
end
