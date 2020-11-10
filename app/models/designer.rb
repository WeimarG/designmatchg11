class Designer
    include Mongoid::Document

    field :name,  type: String
	field :lastname,  type: String
    field :email,  type: String
    
    has_many :designs
end
