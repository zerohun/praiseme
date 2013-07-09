class StampSuggestion 
  def self.name_for(prefix)

#  Rails.cache.fetch(["search-names",prefix]) do
      keywords = prefix.split(' ')
      query_keywords = keywords.map { |key| "(search_keywords.text like '%#{key}%')"}.join(" or ")
      suggestion = Stamp.joins("left outer join search_keywords on search_keywords.target_id = stamps.id and search_keywords.target_type = 'Stamp'").
                        where("(stamps.title like ?) or (search_keywords.text like ?) or #{query_keywords}", "%#{prefix}%", "%#{prefix}%").
                        group("stamps.id").
                        reorder("
                                case 
                                  when stamps.title = '#{prefix.to_s}' then 50
                                  when stamps.title like '%#{prefix.to_s}%' then 20
                                  else 
                                    search_keywords.priority
                                end desc
                                ")


      suggestion.limit(5).pluck(:title)
 #   end
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
