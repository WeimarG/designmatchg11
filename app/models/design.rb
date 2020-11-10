class Design < ApplicationRecord
  validates :path_original_design, presence:true
  validates :path_modified_design, presence:false
  validates :price, presence:true
  
  belongs_to :project
  belongs_to :designer
  belongs_to :state

  mount_uploader :path_original_design, PictureUploader
end
