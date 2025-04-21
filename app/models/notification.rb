class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  scope :unread, -> { where(read: false) }
end
