# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def uploaded_png_file(path, file_name)
  ActionDispatch::Http::UploadedFile.new :filename => file_name, 
                                          :type => "image/png",
                                          :tempfile => File.open(path, 'r')

end


DefaultTrophyImage.create :file => uploaded_png_file("#{Rails.root}/public/default_trophy_images_seed/thumb_badge.png", "thumb_badge.png")
DefaultTrophyImage.create :file => uploaded_png_file("#{Rails.root}/public/default_trophy_images_seed/medal_badge.png", "medal_badge.png")
DefaultTrophyImage.create :file => uploaded_png_file("#{Rails.root}/public/default_trophy_images_seed/trophy_badge.png", "trophy_badge.png")


