class LikesController < ApplicationController
  before_action :authenticate_user!

  def like_toggle
    like = Like.find_by(user_id: current_user.id,
      post_id: params[:post_id])

    if like.nil?
      Like.create(user_id: current_user.id,
        post_id: params[:post_id])
    else
      like.destroy
    end
    # rails 4의 rediret_to :back를 개선한 rails 5 의 redirect_back
    redirect_back(fallback_location: posts_path)
  end
end
