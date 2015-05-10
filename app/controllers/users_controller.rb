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

  def user_params
    params.require(:user).permit(:name, :nickname, role_ids: [])
  end

end
