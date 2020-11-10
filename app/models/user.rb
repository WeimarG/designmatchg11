class User

	include Mongoid::Document

	field :company, type: String
	field :email, type: String
	field :password, type: String
	field :password_confirmation, type: String
	field :slug, type: String
	field :token, type: String
	
	def self.authenticate(email, password)
		user = find_by(email: email)
		if user && user.password == password
			return user
		else
			nil
		end
	end
end
