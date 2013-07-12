class StampsController < ApplicationController
  before_action :set_stamp, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!


  # GET /stamps
  # GET /stamps.json
  def index
    @stamps = Stamp.where("")
    if params[:term].present?
      keywords = params[:term].split(' ')
      query_by_keywords = keywords.map { |keyword|
        "(search_keywords.text like '%#{keyword}%')"
      }.join(" or ")
      @stamps = @stamps.joins("left outer join search_keywords on search_keywords.target_id = stamps.id and search_keywords.target_type = 'Stamp'").
                        where("(stamps.title like ?) or (search_keywords.text like ?) or #{query_by_keywords}", "%#{params[:term]}%", "%#{params[:term]}%").
                        group("stamps.id").
                        reorder("
                                case 
                                  when stamps.title = '#{params[:term].to_s}' then 50
                                  when stamps.title like '%#{params[:term].to_s}%' then 20
                                  else 
                                    search_keywords.priority
                                end desc
                                ")
    end

    @mine_stamp_list = UserStamp.where(:user_id =>5).pluck(:stamp_id)
    if(@mine_stamp_list.empty?) 
      @stamps = @stamps.order("created_at desc")
    else
      @stamps = @stamps.order("case when id in (#{@mine_stamp_list.join(',')})  then 50 else 10 end desc, created_at desc")
    end
    @stamps = @stamps.page(params[:page]).per(15)
    respond_to do |format|
      format.html {}
      format.json {render :json => @stamps.map {|stamp| {:label => stamp.title, :id => stamp.id}}}
      format.js {}
    end
  end

  # GET /stamps/1
  # GET /stamps/1.json
  def show
    @users = @stamp.users
    @users = @users.reorder("user_stamps.score desc")
    @users = @users.page(params[:page]).per(20)
  end

  # GET /stamps/new
  def new
    @stamp = Stamp.new
  end

  # GET /stamps/1/edit
  def edit
  end

  # POST /stamps
  # POST /stamps.json
  def create
    @stamp = Stamp.new(stamp_params)
    respond_to do |format|
      if @stamp.save
        format.html { redirect_to @stamp, notice: 'Stamp was successfully created.' }
        format.json { render :json => {:id => @stamp.id} }
      else
        format.html { render action: 'new' }
        format.json { render json: @stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stamps/1
  # PATCH/PUT /stamps/1.json
  def update
    respond_to do |format|
      if @stamp.update(stamp_params)
        format.html { redirect_to @stamp, notice: 'Stamp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stamps/1
  # DELETE /stamps/1.json
  def destroy
    @stamp.destroy
    respond_to do |format|
      format.html { redirect_to stamps_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stamp
      @stamp = Stamp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stamp_params
      params.require(:stamp).permit(:title, :default_trophy_image_id, :description, :used_count, :is_blocked, :compliments_attributes => [:receiver_id, :sender_id, :description])
    end
end
