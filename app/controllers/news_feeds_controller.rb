class NewsFeedsController < ApplicationController
  before_action :set_news_feed, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /news_feeds
  # GET /news_feeds.json
  def index
    @news_feeds = current_user.news_feeds
  end

  # GET /news_feeds/1
  # GET /news_feeds/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_feed
      @news_feed = current_user.news_feeds.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_feed_params
      params.require(:news_feed).permit(:notifiable_id, :notifiable_type, :action)
    end
end
