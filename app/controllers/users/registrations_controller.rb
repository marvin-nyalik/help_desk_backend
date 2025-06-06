# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json
  
    private
  
    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: { message: 'Signed up successfully.', user: resource }, status: :created
      else
        render json: { error: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def sign_up(resource_name, resource)
    end
end
  