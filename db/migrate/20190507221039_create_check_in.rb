class CreateCheckIn < ActiveRecord::Migration
  def change
    create_table :check_in do |t|
      t.string :student_id
      t.datetime :check_in
      t.datetime :check_out

      t.timestamps null: false
    end
  end
end
