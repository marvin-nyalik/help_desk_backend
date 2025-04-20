# app/models/jwt_allowlist.rb
class JwtAllowlist < ApplicationRecord
    def self.jwt_revoked?(payload, user)
      user.jwt_jti != payload['jti']
    end
  
    def self.revoke_jwt(payload, user)
      user.update(jwt_jti: nil)
    end
  end
  