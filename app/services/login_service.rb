# frozen_string_literal: true

class LoginService < BaseService
  def initialize(safe_params)
    super()
    @email = safe_params[:email]
    @password = safe_params[:password]
  end

  def call
    validate
    return self if error?

    @result = JsonWebTokenManager.encode(@user.id)
  end

  private

  attr_reader :email, :password

  def validate
    @user = User.find_by(email: @email)

    return add_error(I18n.t('errors.authentication.login_fail')) if @user.blank?

    add_error(I18n.t('errors.authentication.login_fail')) if @user.authenticate(@password) == false
  end
end
