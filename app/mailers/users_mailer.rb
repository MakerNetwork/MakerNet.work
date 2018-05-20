class UsersMailer < BaseMailer
  def notify_user_account_created(user, generated_password)
    @user = user
    @generated_password = generated_password
    @fablab_name = Setting.find_by(name: 'fablab_name').value

    mail(
      to: @user.email,
      subject: t('users_mailer.notify_user_account_created.subject', {FABLAB: @fablab_name})
    )
  end
end
