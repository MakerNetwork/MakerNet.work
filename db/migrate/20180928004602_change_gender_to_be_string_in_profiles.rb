class ChangeGenderToBeStringInProfiles < ActiveRecord::Migration
  def change
 
    reversible do |directive|
      change_table :profiles do |t|
        profiles = Profile.all

        directive.up do
          t.change :gender, :string

          profiles.each do |profile|
            case profile.gender
            when 'true'  then profile.gender = 'man'
            when 'false' then profile.gender = 'woman'
            end
            profile.save
          end
        end

        directive.down do
          profiles.each do |profile|
            case profile.gender
            when 'man' then profile.gender = true
            else profile.gender = false
            end
            profile.save
          end
          t.change :gender, 'boolean USING CAST(gender AS boolean)'
        end
      end
    end
  end
end
