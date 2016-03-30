# Reviewed
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, 
                :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    #raise params.inspect
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
      flash[:success] = "Profile updated"      
      sign_in @user
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_token)
    end

    # def signed_in_user
    #   #raise signed_in?.inspect
    #   #flash[:notice] = "Please sign in."
    #   #redirect_to signin_path, notice: "Please sign in." unless signed_in?
    #   unless signed_in?
    #     store_location
    #     redirect_to signin_path, notice: "Please sign in."
    #   end
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
