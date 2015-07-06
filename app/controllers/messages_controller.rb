class MessagesController < ApplicationController

	#Displays all messages, newest ones first
	def index
		@messages = Message.all.order('created_at DESC')
	end

	#Displays all messages for a specific country
	def show
		@messages = Message.where(recipient: params[:id]).order('created_at DESC')
	end

	def new
		@message = Message.new
	end


	def create
		@message = Message.new(message_params)
		#Is asking for the first element in Game is the best/correct way to get the current game?
		@message.round_number = Game.first.round
		@message.game_id = Game.first.id

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
