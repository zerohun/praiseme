class CommentsController < ApplicationController
  def create
    compliment = Compliment.find(params[:compliment_id])
    @comment = compliment.comments.new comment_params
    if params[:last_comment_id].present?
      @comments = compliment.comments.where("comments.id > ?", params[:last_comment_id])
    else
      @comments = [@comment]
    end
    @comment.user = current_user
    if @comment.save
    else
      render :js => "alert('Writing comment is failed. please try again later')"
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    if @comment.is_destroyable_by? current_user
      @comment.destroy
      if params[:compliment_id].present?
        compliment = Compliment.find(params[:compliment_id])
        redirect_to compliment
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
