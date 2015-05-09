class Auth::CallbacksController < ApplicationController
  def flickr

    auth_hash = request.env['omniauth.auth']

    @user = User.joins(:authentications).find_by(
        'authentications.uid' => auth_hash[:uid],
        'authentications.provider' => 'flickr'
    )
    unless @user
      user = User.create_from_omniauth(auth_hash)
      user.authentications << Authentication.new_from_omniauth(auth_hash)
    end

    request.env['warden'].set_user @user
    redirect_to :root, notice: t('sessions.flash.you_have_been_signed_in')
  end

  def failure
  end
end
