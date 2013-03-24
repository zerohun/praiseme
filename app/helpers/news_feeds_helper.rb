module NewsFeedsHelper
  def render_news_feed(news_feed)
    render :partial => "/news_feeds/#{news_feed.notifiable_type.downcase}", :locals => {:news_feed => news_feed}
  end
end
