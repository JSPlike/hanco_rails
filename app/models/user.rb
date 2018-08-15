class User < ApplicationRecord

  rolify
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable


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


  after_create :set_default_role, if: Proc.new { User.count > 1 }

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  validates_presence_of :name
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)
    
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user 
    
    if user.nil?

      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registratio
      #없는 유저라면 새로 생성  
      if user.nil?

        user = User.new(
          name: auth.info.name || auth.extra.nickname ||  auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
        end
      end

    if identity.user != user
      identity.user = user
      identity.save!
    end

    user

  end
  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
  
  private

  def set_default_role
    add_role :user
  end

end
