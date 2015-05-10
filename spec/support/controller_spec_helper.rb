module ControllerSpecHelper
  # Fake a signed in user.
  def set_current_user(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
end