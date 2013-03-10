class Stamp < ActiveRecord::Base
  validates_presence_of :title
  mount_uploader :image_file, ImageFileUploader

end
