class User
	include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :phone, type: String
  field :seq_id, type: Integer

  has_and_belongs_to_many :groups, :class_name => 'Group'

  def to_hash
  	return {
  		name: self.name,
  		email: self.email,
  		phone: self.phone,
  		id: self.seq_id
  	}
  end
end