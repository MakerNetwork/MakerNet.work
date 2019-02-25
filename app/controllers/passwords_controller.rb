class PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def create
    @user = User.find_by_email resource_params[:email]

    unless @user.nil?
      @user.send :set_reset_password_token
      token = @user.reset_password_token

      UsersMailer.delay.notify_user_forgot_password(resource, token)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      head 404
    end
  end

  def update
    @user = User.find_by_reset_password_token(resource_params[:reset_password_token])

    unless @user.nil?
      @user.update_attributes(password: resource_params[:password], password_confirmation: resource_params[:password_confirmation])
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      head 404
    end
  end
end
