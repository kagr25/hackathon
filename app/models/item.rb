class Item
	include Mongoid::Document
	field :name, type: String
	field :item_id, type: String, default: ""
	field :price, type: Integer, default: 0
	
	#embedded_in :order, :class_name => 'Order'
end