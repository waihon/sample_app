# Reviewed
class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      # @feed_items will be empty instead of nil when the user
      # doesn't have any micropost.
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    # @micropost is set in "correct_user" filter
    @micropost.destroy
    redirect_to root_path
  end

  private

    def correct_user
      # Each delete link has the ID of the corresponding micropost, 
      # e.g. http://localhost:3000/microposts/247
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

    def micropost_params
      params.require(:micropost).permit(:content, :user_id)
    end
end