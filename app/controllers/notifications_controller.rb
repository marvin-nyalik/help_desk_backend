class NotificationsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @notifications = current_user.notifications.order(created_at: :desc)
      render json: @notifications
    end
  
    def mark_as_read
      notification = current_user.notifications.find_by(id: params[:id])
      if notification
        notification.update(read: true)
        render json: { message: "Marked as read" }
      else
        render json: { error: "Not found" }, status: :not_found
      end
    end
end
  
