json.array!(@news_feeds) do |news_feed|
  json.extract! news_feed, :notifiable_id, :notifiable_type, :action
  json.url news_feed_url(news_feed, format: :json)
end