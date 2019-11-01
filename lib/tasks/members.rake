namespace :db do

  namespace :members do
    desc "Create member accounts loading data from a CSV file"
    task :load, [:file] => :environment do |task, args|
      unless args.file
        fail 'FATAL ERROR: You must provide the path to the CSV file with the members data!'
      end

      require 'csv'

      CSV.foreach(args.file, headers: true) do |row|
        generated_password = Devise.friendly_token.first(8)

        user = User.new(
          username: row['username'],
          email:    row['email']   ,
          group_id: Group.find_by(slug: 'standard').id,
          password: generated_password,
          password_confirmation: generated_password,
          profile_attributes: {
            first_name: row['first_name'],
            last_name:  row['last_name'] ,
            birthday:   row['birthday'] || Date.today,
            phone:      row['phone']    || '1223334444'
          }
        )

        if user.valid?
          user.save
          UsersMailer.delay.notify_user_account_created(user, generated_password)
        else
          p user.errors.full_messages
        end
      end
    end
  end

end
