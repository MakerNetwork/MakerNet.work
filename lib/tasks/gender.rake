namespace :import do
  # Give a description for the task
  desc 'Import gender from file'

  # Define the task
  task gender: :environment do

    profiles = Profile.all
    profiles.each do |profile|
      case (profile.gender)
      when 'true'
      profile.gender = 'man'
      when 'false'
        profile.gender = 'woman'
      else
        profile.gender = 'non-binary'
       end
      profile.save
    end
  end
end