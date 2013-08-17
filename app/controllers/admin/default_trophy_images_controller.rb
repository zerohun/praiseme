class Admin::DefaultTrophyImagesController < Admin::ApplicationController
  before_action :set_default_trophy_image, only: [:show, :edit, :update, :destroy]

  # GET /admin/default_trophy_images
  def index
    @default_trophy_images = DefaultTrophyImage.where("").page(params[:page]).per(20)
  end

  # GET /admin/default_trophy_images/1
  def show
  end

  # GET /admin/default_trophy_images/new
  def new
    @default_trophy_image = DefaultTrophyImage.new
  end

  # GET /admin/default_trophy_images/1/edit
  def edit
  end

  # POST /admin/default_trophy_images
  def create
    @default_trophy_image = DefaultTrophyImage.new(default_trophy_image_params)
    if @default_trophy_image.save
      redirect_to admin_default_trophy_images_path, notice: 'Default trophy image was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/default_trophy_images/1
  def update
    if @default_trophy_image.update(default_trophy_image_params)
      redirect_to [:admin, @default_trophy_image], notice: 'Default trophy image was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/default_trophy_images/1
  def destroy
    @default_trophy_image.destroy
    redirect_to admin_default_trophy_images_url, notice: 'Default trophy image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_default_trophy_image
      @default_trophy_image = DefaultTrophyImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def default_trophy_image_params
      params[:default_trophy_image].permit(:file)
    end
end
