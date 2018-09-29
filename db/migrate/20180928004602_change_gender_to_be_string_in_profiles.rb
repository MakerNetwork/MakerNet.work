class ChangeGenderToBeStringInProfiles < ActiveRecord::Migration
  def change
    change_column :profiles, :gender, :string
  end
end
