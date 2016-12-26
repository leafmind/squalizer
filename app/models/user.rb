class User < ApplicationRecord
  has_many :locations
  has_many :transactions
  has_many :reports

  after_save { FetchDataJob.perform_later(self) if self.state.to_sym == :fetch }

  scope :sandbox, -> {where(sandbox: true)}

  def self.from_omniauth(auth_data)
    auth = OpenStruct.new(auth_data)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.new(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.email)
      user.token = auth.credentials.token
      user.save!
    end
    user
  end
end
