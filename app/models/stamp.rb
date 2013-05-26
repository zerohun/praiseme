class Stamp < ActiveRecord::Base
  validates_presence_of :title

  has_many :compliments, :dependent => :destroy
  has_many :user_stamps, :dependent => :destroy
  accepts_nested_attributes_for :compliments

  mount_uploader :image, ImageFileUploader
end
