class User < ApplicationRecord

    validates :company, presence:true
	validates :email, presence:true
	validates :password, presence:true
	validates :password_confirmation, presence:true

    validates_uniqueness_of :email  
	validates_uniqueness_of :slug
	
	def self.authenticate(email, password)
		user = find_by(email: email)
		if user && user.password == password
			return user
		else
			nil
		end
	end
end
