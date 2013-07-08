class Admin::ComplimentsController < Admin::ApplicationController
  def index
    @compliments = Compliment.page(params[:page]).per(20)
  end

  def show
    @compliment = Compliment.find(params[:id])
  end

  def edit
    @compliment = Compliment.find(params[:id])
  end

  def update
    @compliment = Compliment.find(params[:id])
    if @compliment.update_attributes(compliment_params)
      redirect_to admin_compliments_path, :notice  => "Successfully updated compliment."
    else
      render :edit
    end
  end

  def destroy
    @compliment = Compliment.find(params[:id])
    @compliment.destroy
    redirect_to admin_compliments_url, :notice => "Successfully destroyed compliment."
  end
  private
  def compliment_params
    params.require(:compliment).permit(:stamp_id)
  end
end
