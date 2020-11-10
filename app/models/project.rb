class Project < ApplicationRecord
  validates :name_project, presence:true
	validates :description, presence:true
	validates :e_value, presence:true

  belongs_to :user
  has_many :designs, dependent: :destroy
  has_many :designers, :through => :designs

  def company
    Rails.application.routes.url_helpers.company_url(slug: :user.slug)
  end
end
