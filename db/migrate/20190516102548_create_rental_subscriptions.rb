class CreateRentalSubscriptions < ActiveRecord::Migration
  def change
    create_table :rental_subscriptions do |t|
      t.belongs_to :rental, index: true
      t.belongs_to :user, index: true
      t.string :stp_rental_subscription_id

      t.timestamps
    end
  end
end
