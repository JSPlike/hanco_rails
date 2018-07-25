class CommentsController < ApplicationController
  #댓글 쓰기전 로그인 확인
  before_action :authenticate_user!
  #수정 삭제시 본인 확인
  before_action :check_ownership!, only: [:update, :destroy]

  def create
    new_comment = Comment.new(content: params[:content],
                              post_id: params[:post_id],
                              user_id: current_user.id)

    new_comment.save

    redirect_back(fallback_location: posts_path)
  end

  def destroy
    @comment.destroy
    redirect_back(fallback_location: posts_path)
  end

  private
  def check_ownership!
    @comment = Comment.find_by(id: params[:id]) 
    redirect_to root_path if @comment.user.id != current_user.id
  end

end
