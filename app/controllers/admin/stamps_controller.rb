class Admin::StampsController < Admin::ApplicationController

  before_filter :is_admin_login

  def index


    @stamps = Stamp.page(params[:page]).per(20)
    
  end

  def show
    @stamp = Stamp.find(params[:id])
  end

  def new
    @stamp = Stamp.new
  end

  def create
    @stamp = Stamp.new(stamp_params)
    if @stamp.save
      redirect_to [:admin, @stamp], :notice => "Successfully created stamp."
    else
      render :new
    end
  end

  def edit
    @stamp = Stamp.find(params[:id])
  end

  def update
    @stamp = Stamp.find(params[:id])
    if @stamp.update_attributes(stamp_params)
      redirect_to admin_stamps_path, :notice  => "Successfully updated stamp."
    else
      render :edit
    end
  end

  def destroy
    @stamp = Stamp.find(params[:id])
    @stamp.destroy
    redirect_to admin_stamps_url, :notice => "Successfully destroyed stamp."
  end
  private
  def stamp_params
    params.require(:stamp).permit(:title, :description, :default_trophy_image_id)
  end
end
