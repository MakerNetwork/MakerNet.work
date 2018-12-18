class UsersMailer < BaseMailer
  def fablab_name
    Setting.find_by(name: 'fablab_name').value
  end

  def notify_user_account_created(user, generated_password)
    @user  = user
    @token = user.reset_password_token
    @generated_password = generated_password

    mail(
      to: @user.email,
      subject: t('users_mailer.notify_user_account_created.subject', {FABLAB: fablab_name})
    )
  end

  def notify_user_forgot_password(user, token)
    @user  = user
    @token = token

    mail(
        to: @user.email,
        subject: t('users_mailer.notify_user_forgot_password.subject', {FABLAB: fablab_name})
    )
  end
end
