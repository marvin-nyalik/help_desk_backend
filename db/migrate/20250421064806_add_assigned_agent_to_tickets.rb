class AddAssignedAgentToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :assigned_agent_id, :integer
  end
end
