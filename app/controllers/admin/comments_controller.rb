class Admin::CommentsController < Admin::ApplicationController


  before_filter :is_admin_login
 
  def index
    @comments = Comment.all
    if params[:q].present?
    end

    @comments = @comments.order("created_at desc")
    @comments = @comments.page(params[:page]).per(20)
  end

  def show
    @comment = Comment.find(params[:id])
  end


  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(comment_params)
      redirect_to [:admin, @comment], :notice  => "Successfully updated comment."
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_url, :notice => "Successfully destroyed comment."
  end
  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
