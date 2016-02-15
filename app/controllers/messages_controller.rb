class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :authenticate_control!
	#Displays all messages, newest ones first
	def index
		@messages = Message.all.order('created_at DESC')
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
		@message = Message.new(message_params)
		#Is asking for the first element in Game is the best/correct way to get the current game?
		@message.round_number = Game.last.round
		@message.game_id = Game.last.id

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
