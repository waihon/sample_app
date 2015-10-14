class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      # To avoid @feed_items being nil which will cause run-time error.
      #@feed_items = current_user.feed.paginate(page: params[:page])
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

    def micropost_params
      params.require(:micropost).permit(:content, :user_id)
    end
end