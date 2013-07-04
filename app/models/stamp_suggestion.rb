class StampSuggestion < ActiveRecord::Base
  def self.name_for(prefix)

 #   Rails.cache.fetch(["search-names",prefix]) do
      suggestion = where("name like ?", "#{prefix}%")
      suggestion.order("popularity desc").limit(5).pluck(:name)
  #  end
  end

  def self.index_names
    Stamp.find_each do |stamp|
      index_stamp(stamp.title)
      stamp.title.split.each { |s| index_stamp(s)}
    end
  end

  def self.index_stamp(name)
    where(name: name.downcase).first_or_initialize.tap do |sug|
      sug.increment! :popularity
    end
  end
end
