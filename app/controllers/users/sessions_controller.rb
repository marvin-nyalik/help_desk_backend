# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController 
    include ActionController::MimeResponds
    respond_to :json 

    def create
      self.resource = warden.authenticate!(auth_options)
      resource.jwt_jti = SecureRandom.uuid
      resource.save!
      sign_in(resource_name, resource)
      render json: {
        message: "Signed in successfully",
        token: request.env['warden-jwt_auth.token']
      }, status: :ok
    end
  
    def destroy
      current_user.update(jwt_jti: nil)
      render json: { message: "Signed out" }
    end

    protected

  def respond_to_on_destroy
    render json: { message: "Signed out" }, status: :ok
  end
  end
  