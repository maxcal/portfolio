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
    @auth_hash = request.env['omniauth.auth']
    @auth = Authentication.joins(:user).find_by(uid: @auth_hash[:uid], provider: 'flickr')

    unless @auth
      @auth = Authentication.create_from_omniauth(@auth_hash)
    end

    unless @auth.user
      @user = User.new_from_omniauth(@auth_hash)
      @auth.user = @user
      @auth.save!
    end

    # sign in the user
    request.env['warden'].set_user @user
    redirect_to :root, notice: t('sessions.flash.you_have_been_signed_in')
  end

end