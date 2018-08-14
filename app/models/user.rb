class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_oauth(auth, signed_in_resource = nil)
    
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    
    
    #없는 유저라면 새로 생성
    
    if user.nil?

      # 이메일 존재 유무 확인
      email = auth.info.email
      user = User.where(:email => email).first

      unless self.where(email: auth.info.email).exists?
        # 없다면 새로운 데이터를 생성한다.

        if user.nil?
          # 카카오는 email을 제공하지 않음

          if auth.provider == "kakao"
            # provider(회사)별로 데이터를 제공해주는 hash의 이름이 다릅니다.

            # 각각의 omnaiuth별로 auth hash가 어떤 경로로, 어떤 이름으로 제공되는지 확인하고 설정해주세요.

            user = User.new(
              profile_img: auth.info.image,
              
              # 이 부분은 AWS S3와 연동할 때 프로필 이미지를 저장하기 위해 필요한 부분입니다.

              # remote_profile_img_url: auth.info.image.gsub('http://','https://'),

              password: Devise.friendly_token[0,20]
            )

          else
            user = User.new(
              email: auth.info.email,
              profile_img: auth.info.image,
              # remote_profile_img_url: auth.info.image.gsub('http://','https://'),

              password: Devise.friendly_token[0,20]
            )
          end
          user.save!
        end
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user

  end

  # email이 없어도 가입이 되도록 설정

  def email_required?
    false
  end
  
  has_many :posts
  has_many :likes
  has_many :comments
  # 어떤것을 통해 like 값을 가져오는지 명시해줘야한다 through: :likes
  # 그게 source: ...
  has_many :liked_posts, through: :likes, source: :post

  mount_uploader :avatar, AvatarUploader

  has_many :projects
  # 좋아요를 얼마나 클릭하였는지 확인
  # present?는 안에 값이 있으면 true 없으면 false를 반환한다
  def is_like?(post)
    Like.find_by(user_id: self.id,
      post_id: post.id).present?
  end
end
