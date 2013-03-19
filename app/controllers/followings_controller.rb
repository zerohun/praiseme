class FollowingsController < ApplicationController
  before_action :set_following, only: [:destroy]

  # GET /followings
  # GET /followings.json
  def index
    @followings = Following.all
  end

  # POST /followings
  # POST /followings.json
  def create
    @following = Following.new(following_params)
    @following.follower = current_user

    respond_to do |format|
      if @following.save
        format.html { redirect_to @following, notice: 'Following was successfully created.' }
        format.json { render action: 'show', status: :created, location: @following }
        format.js { render action: 'create'}
      else
        format.html { render action: 'new' }
        format.json { render json: @following.errors, status: :unprocessable_entity }
        format.js {render script: "alert('error');"}
      end
    end
  end

  # DELETE /followings/1
  # DELETE /followings/1.json
  def destroy
    @following.destroy
    respond_to do |format|
      format.html { redirect_to followings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_following
      @following = Following.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def following_params
      params.require(:following).permit(:followee_id)
    end
end
