class Project 
  
  include Mongoid::Document

  field :name_project, type: String
	field :description, type: String
	field :e_value, type: String

  belongs_to :user
  has_many :designs, dependent: :destroy
  has_many :designers

  def company
    Rails.application.routes.url_helpers.company_url(slug: :user.slug)
  end
end
