module SessionsHelper

  # @return [User|nil]
  def current_user
    request.env['warden'].user
  end

  # @return bool
  def signed_in?
    ! current_user.nil?
  end
end