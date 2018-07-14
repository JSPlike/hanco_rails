class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :posts
  has_many :likes
  # 어떤것을 통해 like 값을 가져오는지 명시해줘야한다 through: :likes
  # 그게 source: ...
  has_many :liked_posts, through: :likes, source: :post

  mount_uploader :avatar, AvatarUploader

  # 좋아요를 얼마나 클릭하였는지 확인
  # present?는 안에 값이 있으면 true 없으면 false를 반환한다
  def is_like?(post)
    Like.find_by(user_id: self.id,
      post_id: post.id).present?
  end
end
