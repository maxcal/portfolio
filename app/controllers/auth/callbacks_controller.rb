class Auth::CallbacksController < ApplicationController
  def flickr
    handle_callback('flickr')
  end

  # Failed authentications get patched through to this action
  def failure
    flash[:alert] = t(
        "auth.failure.flashes.#{params[:message]}",
        default: t('auth.failure.flashes.default', message: params[:message])
    )
    redirect_to root_path
  end

  private

  def handle_callback(provider)
    @user = AuthServices::Authenticate.new.call(request.env['omniauth.auth'])

    if @user == User.first
      @user.add_role(:admin)
    end

    # sign in the user
    sign_in @user
    redirect_to :root, notice: t('sessions.flash.you_have_been_signed_in')
  end
end