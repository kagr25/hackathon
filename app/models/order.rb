class Order
	include Mongoid::Document
	include Mongoid::Timestamps
	field :amount, type: Integer, default: 0
	field :saving, type: Integer, default: 0
	field :shipping_price, type: Integer, default: 0
	field :status, type: String, default: "Queued"
	field :order_id, type: Integer, default: 12345
	field :selected_group_id, type: String, default: ''

	belongs_to :user, :class_name => 'User'
	has_and_belongs_to_many :groups, :class_name => 'Group', :autosave => true
	#embeds_many :items, :class_name => 'Item'


	def to_hash
		return {
			time: self.created_at.strftime("%d-%m-%Y"),
			amount: self.amount,
			saving: self.saving,
			shipping_price: self.shipping_price,
			status: self.status,
			order_id: self.order_id,
			user: self.user.to_hash,
			groups: self.selected_group_id.blank? ? self.groups.collect{|g| g.to_hash(false)} : [Group.where(:group_id => self.selected_group_id).first.to_hash(false)]
		}
	end
end