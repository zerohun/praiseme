module FacebookDataHelper
  def self.get_score_hash(fb_graph, data_type, options = {:like_score => 1, :comment_score => 2, :total_page_num => 5})
    like_score = options[:like_score]
    comment_score = options[:comment_score]
    total_page_num = options[:total_page_num]
    posts = fb_graph.get_connection("me", data_type)
    score_hash = {}
    total_page_num.times do
      break if posts.blank?
      posts.each do |post|
        score_hash = score_hash + extract_score(post, "likes", like_score)
        score_hash = score_hash + extract_score(post, "comments", comment_score)
      end
      posts = posts.next_page
    end
    return score_hash
  end


  def self.extract_score(data_item, field_type, score)
    score_hash = {}
    if data_item[field_type].present?
      data_item[field_type]["data"].each do |each_data|
        score_hash = score_hash + {each_data["id"] => score}
      end
    end
    return score_hash
  end


  def self.get_score_hash_from_friend_list(fb_graph, score)
    score_hash = {}
    friendlists = fb_graph.get_connections("me", "friendlists")
    friendlists.each do |friendlist|
      if friendlist["list_type"] == "close_friends"
        members = fb_graph.get_connection(friendlist["id"], "members")
        members.each do |member|
          score_hash = score_hash + {member["id"] => score}
        end
      end
    end
    return score_hash
  end
end
