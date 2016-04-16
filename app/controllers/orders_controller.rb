class OrdersController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def create
		@order = Order.new({amount: params[:amount], shipping_price: params[:shipping_price]})
		@order.user = User.where(seq_id: params[:user_id].to_i).first
		@order.groups = Group.where(:group_id.in => params[:groups].split(',')).all
		if !Order.last.nil? 
			@order.order_id = Order.last.order_id + 1
		end
		if @order.save
			@order.groups.each do |g|
				g.orders << @order
				g.orders.uniq
				g.save
			end
			OrderProcess.perform_now(@order.id)
			render json: {message: "Success" }, status: 200
		else
			render json: {message: "Failed" }, status: 400
		end

	end

	def index
		@orders = Order.all.collect {|o| o.to_hash}
		render json: {orders: @orders}, status: :ok
	end

	def user_orders
		@orders = Order.where(:user_id => User.where(:seq_id => params[:user_id].to_i).first.try(:id)).all.collect{|o| o.to_hash}
		render json: {orders: @orders}, status: :ok
	end

end