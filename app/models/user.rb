require_relative '../lib/allowListStrategy'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtAllowlist

  before_create :set_initial_jti

  private

  def set_initial_jti
    self.jwt_jti = SecureRandom.uuid
  end
end
