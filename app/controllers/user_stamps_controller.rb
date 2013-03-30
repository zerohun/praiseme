class UserStampsController < ApplicationController
  before_action :set_user_stamp, only: [:show, :edit, :update, :destroy]

  # GET /user_stamps
  # GET /user_stamps.json
  def index
    @user_stamps = UserStamp.all
  end

  # GET /user_stamps/1
  # GET /user_stamps/1.json
  def show
  end

  # GET /user_stamps/new
  def new
    @user_stamp = UserStamp.new(user_stamp_params)
  end

  # GET /user_stamps/1/edit
  def edit
  end

  # POST /user_stamps
  # POST /user_stamps.json
  def create
    @user_stamp = UserStamp.new(user_stamp_params)

    respond_to do |format|
      if @user_stamp.save
        format.html { redirect_to @user_stamp, notice: 'User stamp was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_stamp }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stamps/1
  # PATCH/PUT /user_stamps/1.json
  def update
    respond_to do |format|
      if @user_stamp.update(user_stamp_params)
        format.html { redirect_to @user_stamp, notice: 'User stamp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stamps/1
  # DELETE /user_stamps/1.json
  def destroy
    @user_stamp.destroy
    respond_to do |format|
      format.html { redirect_to user_stamps_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_stamp
      @user_stamp = UserStamp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_stamp_params
      params.require(:user_stamp).permit(:stamp_id, :user_id, :score)
    end
end
