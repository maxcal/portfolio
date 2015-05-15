# Handles user authentication with Warden
# @note in order to facilitate sane controller specs this
#   be the only point in the application which actually touches Warden.
module SessionsHelper
  # Get the current user for the session.
  # @return [User|nil]
  def current_user
    request.env['warden'].user if request.env['warden']
  end
  # Is there a signed in user?
  # @return [Boolean]
  def signed_in?
    ! current_user.nil?
  end
  # Sign out the current user from all scopes
  # @return [Boolean]
  def sign_out!
    request.env['warden'].logout
  end
  # @param [User] user
  # @return [Boolean]
  def sign_in(user)
    request.env['warden'].set_user user
  end
end