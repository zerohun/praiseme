class Stamp < ActiveRecord::Base
  validates_presence_of :title

  has_many :compliments, :dependent => :destroy
  has_many :user_stamps, :dependent => :destroy
  has_many :users, :through => :user_stamps
  has_many :search_keywords, :as => :target
  belongs_to :default_trophy_image
  accepts_nested_attributes_for :compliments


  validates_length_of :title, :maximum => 80

  mount_uploader :image, ImageFileUploader

  after_create do |stamp|
    stamp.delay.create_search_keywords
  end

  def self.name_for(prefix)
 #   Rails.cache.fetch(["search-names",prefix]) do
      suggestion = where("title like ?", "#{prefix}%")
      suggestion.order("title asc").limit(5).pluck(:title)
  #  end
  end

  def create_search_keywords
    simliar_keywords = SynonymsFinderClient.find_of(self.title)
    simliar_keywords.each_pair do |key, items|
      if key == :phrase
        items.each do |item|
          self.search_keywords.create :text => item, :priority => 10
        end
      elsif key == :noun
         items.each do |item|
          self.search_keywords.create :text => item, :priority => 9
        end
      else
         items.each do |item|
          self.search_keywords.create :text => item, :priority => 5
        end
      end
    end
  end
end
