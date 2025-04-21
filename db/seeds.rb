# db/seeds.rb
require 'securerandom'

puts "Seeding users..."

users = [
  { email: 'admin@example.com', password: 'password', role: 'Admin' },
  { email: 'agent1@example.com', password: 'password', role: 'Agent' },
  { email: 'agent2@example.com', password: 'password', role: 'Agent' },
]

# Add 7 clients
7.times do |i|
  users << {
    email: "client#{i + 1}@example.com",
    password: 'password',
    role: 'Client'
  }
end

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.password = attrs[:password]
  user.role = attrs[:role]
  user.jwt_jti = SecureRandom.uuid
  user.save!
end

puts "✅ Seeded #{users.size} users successfully!"

# Get references
admin = User.find_by(email: 'admin@example.com')
agents = User.where(role: 'Agent')
clients = User.where(role: 'Client')

puts "Seeding tickets..."

departments = ["IT", "HR", "Finance"]
priorities = ["Low", "Medium", "High"]
statuses = Ticket::STATUSES

tickets = []

clients.each_with_index do |client, idx|
  2.times do |n|
    ticket = Ticket.create!(
      user: client,
      subject: "Issue ##{n + 1} for #{client.email}",
      department: departments.sample,
      description: "This is a description of a problem faced by #{client.email}.",
      priority: priorities.sample,
      status: statuses.sample # Can also default to "Open"
    )
    tickets << ticket
  end
end

puts "✅ Seeded #{tickets.size} tickets from clients."

# Assign some tickets to agents
puts "Assigning some tickets to agents..."

tickets.sample(6).each_with_index do |ticket, idx|
  agent = agents[idx % agents.count] # Alternate between agents
  ticket.update!(assigned_agent_id: agent.id)
  Notification.create!(
    user: agent,
    ticket: ticket,
    message: "You have been assigned ticket ##{ticket.ticket_id}",
    read: false
  )
end

puts "✅ Assigned 6 tickets to agents with notifications."

puts "🎉 Seeding complete!"
