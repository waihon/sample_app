module SessionsHelper
  def sign_in(user)
    # Permanent cookies
    # cookies[:remember_token] = { value: user.remember_token,
    #                              expires: 20.years.from_now }
    cookies.permanent[:remember_token] = user.remember_token

    # There's a subtle error here. See the addendum at the end 
    # of the lesson for details. The error fixed by adding self.
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    # There's a subtle error here. See the addendum at the end 
    # of the lesson for details: Added self
    self.current_user = nil
    cookies.delete(:remember_token)
  end    

  # Friendly forwarding
  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    # Everything after redirect_to will be executed as well before actual redirect.
    # The return_to session need to be deleted so that a fresh sign in would 
    # redirect user to Profile page, which is the application's default.    
    session.delete(:return_to)
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end
end
