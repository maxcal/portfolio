class SessionsController < ApplicationController

  def destroy
    request.env['warden'].logout
    redirect_to root_path, notice: t('sessions.flash.you_have_been_signed_out')
  end
end