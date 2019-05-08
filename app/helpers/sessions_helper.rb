module SessionsHelper
  #Logs in the given user.
  #Temporarly cookies created using session are automatically encrypted.
  #Different from persistent sessions created using cookies methods.
  #Permenant cookies are vulnerable to sessions hijacking attacks.
  def log_in(user)
    session[:user_id] = user.id
  end

  #Instance variable, which hits the database the first time
  #but returns the instance variable immediately on subsequent invocations
  #return the current logged_in user (if any)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user?(user)
    user == current_user
  end

  #return true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
