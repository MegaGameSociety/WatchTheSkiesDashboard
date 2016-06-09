class MessagesController < ApplicationController
	before_action :authenticate_user!

	#Displays all messages, newest ones first

	layout "mobile"

	def index
		@messages = Message.all.order('created_at DESC')
		@newMessage = Message.new

		respond_to do |format|
			format.html
			format.json { render json: @messages }
		end
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
		@message.round_number = @game.round
		@message.game_id = @game.id

		if @message.save
			redirect_to '/messages'
		else
			render 'new'
		end
	end

	private
		def message_params
			params.require(:message).permit(:sender, :recipient, :content)
		end
end
