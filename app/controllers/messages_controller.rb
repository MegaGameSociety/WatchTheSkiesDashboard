class MessagesController < ApplicationController
	before_action :authenticate_user!

	#Displays all messages, newest ones first

	# Disabling mobile since we aren't using it for now
	# layout "mobile"

	def index
		@teams = Team.all
		# @messages = Message.all.order('created_at DESC')
		# respond_to do |format|
		# 	format.html
		# 	format.json { render json: @messages }
		# end
	end

	def country_messages
		@origin_name = params['country']
		@teams = Team.all.pluck(:team_name).delete_if{|x| x == params['country']}
	end

	def conversation
		@country = params['country']
		@country_name = params['country_name']
		user_team_id = Team.find_by_team_name(params['country']).id
		other_team_id = Team.find_by_team_name(params['country_name']).id
    @messages = Message.where(game: current_game).where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
     user_team_id, other_team_id, other_team_id, user_team_id).order(:created_at)
	end

	#Displays all messages for a specific country
	def show
		@messages = Message.where(recipient: params[:id]).order('created_at DESC')

		respond_to do |format|
			format.html
			format.json { render json: @messages }
		end
	end

	def new
		@message = Message.new
	end

	def create
		@game = current_game

		recipientId = message_params['recipient'].to_i
		senderId = message_params['sender'].to_i

    new_params = message_params.except('recipient', 'sender')
    @message = Message.new(new_params)
    @message.sender = Team.find(senderId)
    @message.recipient = Team.find(recipientId)

		@message.round_number = @game.round
		@message.game_id = @game.id

		@message.save
		render json: @message
	end

	private
		def message_params
			params.require(:message).permit(:country, :sender, :recipient, :content)
		end
end
