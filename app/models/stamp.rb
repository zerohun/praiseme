class Stamp < ActiveRecord::Base
  validates_presence_of :title

  has_many :compliments
  accepts_nested_attributes_for :compliments

  mount_uploader :image, ImageFileUploader
end
