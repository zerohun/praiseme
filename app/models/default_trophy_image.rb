class DefaultTrophyImage < ActiveRecord::Base
  mount_uploader :file, ImageFileUploader
end
