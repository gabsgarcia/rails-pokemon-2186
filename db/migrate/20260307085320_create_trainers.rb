# rails g model Trainer name:string age:integer

class CreateTrainers < ActiveRecord::Migration[7.1]
  def change
    create_table :trainers do |t|
      t.string :name   # the trainer's username / display name
      t.integer :age   # the trainer's age

      t.timestamps # adds created_at and updated_at columns automatically
    end
  end
end
