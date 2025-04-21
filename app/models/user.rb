class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :jwt_jti

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtAllowlist

  before_create :set_initial_jti
  has_many :notifications

  private

  def set_initial_jti
    self.jwt_jti = SecureRandom.uuid
  end
end
