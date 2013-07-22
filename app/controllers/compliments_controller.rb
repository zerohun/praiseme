class ComplimentsController < ApplicationController
  before_action :set_compliment, only: [:show, :edit, :update, :destroy]
  skip_filter :authenticate_user!, only: [:show]

  # GET /compliments
  # GET /compliments.on
  def index
    duplicate_stamp_count = Compliment.where(:sender_id => current_user, :receiver_id => params[:receiver_id], :stamp_id => params[:stamp_id]).count
    render :json => {:count => duplicate_stamp_count } 
  end

  # GET /compliments/1
  # GET /compliments/1.json
  def show
    @compliment = Compliment.find(params[:id])
    @comments = @compliment.comments.reorder("id desc").page(params[:page]).per(5)
    @og_type = "profile"
    user = @compliment.receiver
    @og_title = user.username
    @og_image = user.image_url
    @og_url = "http://#{request.host}/compliments/#{@compliment.id}"
  end

  # GET /compliments/new
  def new
    if params[:compliment][:stamp_id].present?
      @params  = params[:compliment]
      if @params[:receiver_id] ==  current_user.id || Compliment.where(:stamp_id => @params[:stamp_id], :sender_id => current_user.id , :receiver_id => @params[:receiver_id]).count > 0
        redirect_to news_feeds_path
      end 
    end
     count_of_today_compliment = current_user.sent_compliments.where("created_at >= ?", Date.today.beginning_of_day).count
      if(count_of_today_compliment >= 10)
        redirect_to news_feeds_path, :flash => {:compliment =>"Over the Today's Compliment"}
      end


    params.require(:compliment).permit!
    @compliment = Compliment.new(params[:compliment])
    @stamps = []
    DefaultTrophyImage.limit(4).each do |default_trophy_image|
      @stamps << Stamp.new(:title => "", :default_trophy_image_id => default_trophy_image.id)
    end
  end

  # GET /compliments/1/edit
  def edit
  end

  # POST /compliments
  # POST /compliments.json
  def create
    @compliment = Compliment.new(compliment_params)
    @compliment.stamp = Stamp.find_by_title(params[:stamp_text]) if @compliment.stamp_id.blank?
    respond_to do |format|
      @compliment.sender = current_user
      if @compliment.save
        if params[:post_to_facebook].present? && params[:post_to_facebook].to_i == 1
          begin
            current_user.facebook.put_connections "me", "#{$fb_namespace}:glorify",
                                                  :profile => @compliment.object_url(request.host),
                                                  :message => @compliment.description,
                                                  :tag => @compliment.receiver.sns_connections.where(:provider => "facebook").first.uid,
                                                  "fb:explicitly_shared" => true
          rescue Exception
          end
        end
        format.html { redirect_to @compliment, notice: 'Compliment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @compliment }
      else
        format.html { render action: 'new' }
        format.json { render json: @compliment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compliments/1
  # PATCH/PUT /compliments/1.json
  def update
    respond_to do |format|
      if @compliment.update(compliment_params)
        format.html { redirect_to @compliment, notice: 'Compliment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @compliment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compliments/1
  # DELETE /compliments/1.json
  def destroy

    if @compliment.is_destroyable_by? current_user
      #receiver_user_stamp = UserStamp.where(:user_id => @compliment.receiver_id, :stamp_id => @compliment.stamp_id).first
      #sender_user_stamp = UserStamp.first_or_initialize(:user_id => @compliment.sender_id, :stamp_id => @compliment.stamp_id)
      #receiver_user_stamp.update_attribute :score, receiver_user_stamp.score - sender_user_stamp.impact
      @user_stamp = UserStamp.where(:stamp_id => @compliment.stamp_id, :user_id => @compliment.receiver_id).first
      @compliment.destroy

      respond_to do |format|
        format.html { redirect_to @user_stamp}
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compliment
      @compliment = Compliment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compliment_params
      params.require(:compliment).permit(:receiver_id, :stamp_id, :description)
    end
end
