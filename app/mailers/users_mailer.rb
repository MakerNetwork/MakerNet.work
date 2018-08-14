class UsersMailer < BaseMailer
  def notify_user_account_created(user, generated_password)
    @token=user.reset_password_token
    @user = user
    @generated_password = generated_password
    @fablab_name = Setting.find_by(name: 'fablab_name').value
    mail(
      to: @user.email,
      subject: t('users_mailer.notify_user_account_created.subject', {FABLAB: @fablab_name})
    )
  end

  def notify_user_forgot_password(user)
    @user=user
    @token=user.reset_password_token
    @fablab_name = Setting.find_by(name: 'fablab_name').value
    mail(
        to: @user.email,
        subject: t('users_mailer.notify_user_forgot_password.subject', {FABLAB: @fablab_name})
    )
  end



end
