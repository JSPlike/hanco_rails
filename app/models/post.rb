class Post < ApplicationRecord
	mount_uploader :image, PostImageUploader

	belongs_to :user
end
