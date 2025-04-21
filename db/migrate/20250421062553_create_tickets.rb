class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :subject
      t.string :department
      t.text :description
      t.string :priority
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.string :ticket_id
      t.text :notes

      t.timestamps
    end
  end
end
