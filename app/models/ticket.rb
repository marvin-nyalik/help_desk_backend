# app/models/ticket.rb
class Ticket < ApplicationRecord
  STATUSES = %w[Open In\ Progress Resolved Closed]

  belongs_to :user
  belongs_to :assigned_agent, class_name: "User", optional: true
  has_many :notifications

  validates :subject, :department, :description, :priority, presence: true
  validates :ticket_id, uniqueness: true
  validates :status, inclusion: { in: STATUSES }

  before_create :generate_ticket_id
  after_initialize :set_default_status, if: :new_record?


  private

  def generate_ticket_id
    self.ticket_id = "TCKT-#{SecureRandom.hex(4).upcase}"
  end

  def set_default_status
    self.status ||= "Open"
  end
end
