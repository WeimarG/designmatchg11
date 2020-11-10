class Design 
  include Mongoid::Document

  field :path_original_design, type: String
  field :path_modified_design, type: String
  field :price, type: String
  
  belongs_to :project
  belongs_to :designer
  belongs_to :state

  mount_uploader :path_original_design, PictureUploader
end
