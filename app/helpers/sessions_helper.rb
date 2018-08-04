module SessionsHelper

  def log_in user
    session[:user_id] = user.id
    session[:project_id] = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user_id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user? user
    user == current_user
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by id: session[:user_id]
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by id: user_id
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_project
    if project_id = session[:project_id]
      @current_project ||= Project.find_by id: session[:project_id]
    end
  end

  def current_project? project
    project == current_project
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def check_current_prj
    if current_project == nil
      return false
    else
      return true
    end
  end

  def get_assigned_prj user
    tmp = UserProject.includes(:project).where("user_id = ?", user.id)
    list_prj = tmp.all.collect{|k| k.project_id}
    return list_prj
  end

  def get_prj_id
    s = "/projects/"
    x = request.fullpath
    if x.include?(s) == true
      if s.length < x.length
        g = x.split("/projects/")
        if get_assigned_prj(current_user).include?(g[1].to_i) == true
          get_id = g[1].to_i
          session[:project_id] = get_id
        end
      end
    end
  end

end
