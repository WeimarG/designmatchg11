class Designer < ApplicationRecord
    validates :name, presence:true
	validates :lastname, presence:true
    validates :email, presence:true
    
    has_many :designs
end
