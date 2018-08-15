class Identity < ApplicationRecord
  belongs_to :user
  
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { :scope => :provider }

  def self.find_for_oauth(auth)
    identity = find_by(uid: auth.uid, provider: auth.provider)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity
  end
end
