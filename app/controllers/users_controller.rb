class UsersController < ApplicationController

  load_and_authorize_resource

  def show
  end

  def index
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
    end
  end

  def destroy
    is_self = @user == current_user
    sign_out! if is_self
    @user.destroy
    redirect_to :root, notice: is_self ? t('users.flash.destroy.success_self') : t('users.flash.destroy.success')
  end

  def user_params
    params.require(:user).permit(:name, :nickname, role_ids: [])
  end
end
