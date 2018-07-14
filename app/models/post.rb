class Post < ApplicationRecord
	belongs_to :user

	has_many :likes
	# user.rb를 참조하자
	has_many :liked_users, through: :likes, source: :user

	mount_uploader :image, PostImageUploader
end
