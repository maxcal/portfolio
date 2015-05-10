class SessionsController < ApplicationController

  def destroy
    sign_out!
    redirect_to root_path, notice: t('sessions.flash.you_have_been_signed_out')
  end

  def new
    if signed_in?
      redirect_to :root
    end
  end

end