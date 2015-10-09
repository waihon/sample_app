class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  def show
    #raise params.inspect
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App"
      sign_in @user
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    # Below has been moved to correct_user
    # @user = User.find(params[:id])
  end

  def update
    # Below has been moved to correct_user
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_token)
    end

    def signed_in_user
      #raise signed_in?.inspect
      #flash[:notice] = "Please sign in."
      #redirect_to signin_path, notice: "Please sign in." unless signed_in?
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end
