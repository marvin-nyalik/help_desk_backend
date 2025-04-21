class TicketsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_ticket, only: [:show, :update, :close, :reopen, :assign]
    before_action :authorize_admin!, only: [:assign]
  
    def index
      if current_user.role == "Admin"
        @tickets = Ticket.all
      elsif current_user.role == "Agent"
        @tickets = Ticket.where(assigned_agent_id: current_user.id)
      else
        @tickets = current_user.tickets
      end
    
      render json: @tickets
    end
  
    def create
      @ticket = current_user.tickets.build(ticket_params)
      if @ticket.save
        render json: { message: "Ticket created", ticket: @ticket }, status: :created
      else
        render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      render json: @ticket
    end
  
    def update
      if ["Admin", "Agent"].include?(current_user.role)
        @ticket.update(status: params[:status])
        Notification.create!(
          user: @ticket.user,
          ticket: @ticket,
          message: "Your ticket ##{@ticket.ticket_id} status changed to #{@ticket.status}",
          read: false
        )

        render json: { message: "Ticket status updated", ticket: @ticket }
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  
    def close
      @ticket.update(status: "Closed")
      render json: { message: "Ticket closed", ticket: @ticket }
    end
  
    def reopen
      @ticket.update(status: "Open", notes: params[:notes])
      render json: { message: "Ticket reopened", ticket: @ticket }
    end

    def assign    
      agent = User.find_by(id: params[:agent_id], role: "Agent")
      unless agent
        return render json: { error: "Agent not found" }, status: :not_found
      end
    
      if @ticket.update(assigned_agent_id: agent.id)
        Notification.create!(
          user: agent,
          ticket: @ticket,
          message: "You have been assigned ticket ##{@ticket.ticket_id}",
          read: false
        )
        render json: { message: "Ticket assigned to agent", ticket: @ticket }
      else
        render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
  
    private
  
    def set_ticket
      @ticket = Ticket.find_by(ticket_id: params[:id])
      render json: { error: "Ticket not found" }, status: :not_found unless @ticket
    end
  
    def ticket_params
      allowed = [:subject, :department, :description, :priority]
      allowed << :assigned_agent_id if current_user.role == "Admin"
      params.require(:ticket).permit(allowed)
    end

    def authorize_admin!
      unless current_user.role == "Admin"
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
end
  