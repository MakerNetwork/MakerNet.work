class PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    UsersMailer.delay.notify_user_forgot_password(resource)

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      head 404
    end
  end

  def update
    @user = User.find_by_reset_password_token(resource_params[:reset_password_token])

    if @user != nil
      @user.update_attributes(password: resource_params[:password], password_confirmation: resource_params[:password_confirmation])
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      head 404
    end
  end
end
