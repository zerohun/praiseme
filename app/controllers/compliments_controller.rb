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
    @user_stamp = UserStamp.where(:user_id => @compliment.receiver_id, :stamp_id => @compliment.stamp_id).first
    @comments = @compliment.comments.reorder("id desc").page(params[:page]).per(5)
    @og_type = "profile"
    user = @compliment.receiver
    @og_title = user.username
    @og_image = user.image_url
    @og_url = "http://#{request.host}/compliments/#{@compliment.id}"
    @og_description = "I think #{@compliment.receiver.username} is #{@compliment.stamp.title}. Do you agree?"
  end

  # GET /compliments/new
  def new
    if params[:compliment][:stamp_id].present?
      @params  = params[:compliment]
      if @params[:receiver_id] ==  current_user.id || Compliment.where(:stamp_id => @params[:stamp_id], :sender_id => current_user.id , :receiver_id => @params[:receiver_id]).count > 0
        redirect_to news_feeds_path
      end 
    end
     #count_of_today_compliment = current_user.sent_compliments.where("created_at >= ?", Date.today.beginning_of_day).count
      #if(count_of_today_compliment >= 10)
        #redirect_to news_feeds_path, :flash => {:compliment =>"Over the Today's Compliment"}
      #end

    params.require(:compliment).permit!
    @compliment = Compliment.new(params[:compliment])
    @stamps = []
    DefaultTrophyImage.all.each do |default_trophy_image|
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
          @compliment.update_attributes(:is_post => 1)
          og_params_hash = {:profile => @compliment.object_url(request.host), "fb:explicitly_shared" => true}
          if @compliment[:description].present?
            receiver_uid = @compliment.receiver.sns_connections.where(:provider => "facebook").first.uid
            if @compliment[:description].include? @compliment.receiver.username
              og_params_hash.merge!({:message => @compliment[:description].gsub(@compliment.receiver.username, "@[#{receiver_uid}]")})
            else
              og_params_hash.merge!({:message => @compliment[:description]})
            end
          end
          permissions = current_user.facebook.get_connections("me", "permissions").first
          if permissions["publish_actions"].blank? || permissions["publish_actions"] != 1
            @oauth = Koala::Facebook::OAuth.new($fb_app_id, $fb_app_secret, "http://#{request.host}#{":#{request.port}" if request.port != 80}#{compliment_callback_path}")
            format.html { redirect_to @oauth.url_for_oauth_code(:permissions => "publish_actions", :state => {:og_params_hash => og_params_hash, :compliment_id => @compliment.id}.to_json)}
          else
            @res = @compliment.post_og(og_params_hash)
            format.html { redirect_to @compliment, notice: 'Compliment was successfully created.' }
            format.json { render action: 'show', status: :created, location: @compliment }
          end
        else
          format.html { redirect_to @compliment, notice: 'Compliment was successfully created.' }
          format.json { render action: 'show', status: :created, location: @compliment }
        end
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

  def new_permission
    @compliment = Compliment.new compliment_params
    @oauth = Koala::Facebook::OAuth.new($fb_app_id, $fb_app_secret, compliment_callback_path)
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
