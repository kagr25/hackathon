class OrderProcess < ActiveJob::Base
  # Set the Queue as Default
  queue_as :default

  def perform(id)
    @order = Order.find(id)
    @order.groups.each do |group|
    	if 999 <= group.group_total
    		group.orders.each do |ord|
    			ord.status = "Shipping"
    			ord.saving = ord.shipping_price
    			ord.selected_group_id = group.group_id
    			ord.save
    		end
    	end

    end
  end
end