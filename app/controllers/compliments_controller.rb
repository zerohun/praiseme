class ComplimentsController < ApplicationController
  before_action :set_compliment, only: [:show, :edit, :update, :destroy]
  skip_filter :authenticate_user!, only: [:show]
  before_filter :bofre_login_renderable, :only => [:show]

  # GET /compliments
  # GET /compliments.json
  def index
    @compliments = Compliment.all
  end

  # GET /compliments/1
  # GET /compliments/1.json
  def show
    redirect_to UserStamp.where(:stamp_id => @compliment.stamp_id, :user_id => @compliment.receiver_id).first
  end

  # GET /compliments/new
  def new
    params.require(:compliment).permit!
    @compliment = Compliment.new(params[:compliment])
  end

  # GET /compliments/1/edit
  def edit
  end

  # POST /compliments
  # POST /compliments.json
  def create
    @compliment = Compliment.new(compliment_params)

    respond_to do |format|
      @compliment.sender = current_user
      if @compliment.save
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
    @compliment.destroy
    respond_to do |format|
      format.html { redirect_to compliments_url }
      format.json { head :no_content }
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
