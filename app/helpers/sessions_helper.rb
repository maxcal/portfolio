module SessionsHelper

  # @return [User|nil]
  def current_user
    request.env['warden'].user
  end

  # @return [Boolean]
  def signed_in?
    ! current_user.nil?
  end

  # @return [Boolean]
  def sign_out!
    request.env['warden'].logout
  end

  # @return [Boolean]
  def sign_in(user)
    request.env['warden'].set_user user
  end
end