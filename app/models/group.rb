class Group
  include Mongoid::Document
  
  field :name, type: String
  field :group_id, type: String
  field :zip, type: Integer
  field :address, type: String
  field :city, type: String
  field :state, type: String
  
  validates_presence_of :group_id, :name, :zip

  has_and_belongs_to_many :users, :class_name => 'User', :autosave => true
  has_and_belongs_to_many :orders, :class_name => 'Order', :autosave => true


  def to_hash(flag = true)
  	return {
		users: flag ? self.users.collect{|u| u.to_hash} : [],
  		name: self.name,
  		group_id: self.group_id,
  		zip: self.zip,
  		address: self.address,
  		city: self.city,
  		state: self.state,
  		group_total: group_total
  	}
  end

  def group_total
  	total = 0
  	self.orders.each do |o|
  		if o.status == "Queued"
  			total += o.amount
  		end
  	end
  	total
  end
end
