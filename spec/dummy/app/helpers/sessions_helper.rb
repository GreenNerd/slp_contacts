module SessionsHelper
  def current_user
    @current_user ||= sign_in_from_session || sign_in_from_cookies
  end

  def current_user=(user)
    @current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    @current_user = user
    session[:current_user_id] = user.id
    remember_me
  end

  def sign_out
    @current_user = nil
    session[:current_user_id] = nil
    forget_me
  end

  def sign_in_from_session
    if session[:current_user_id].present?
      begin
        User.find session[:current_user_id]
      rescue
        session[:current_user_id] = nil
      end
    end
  end

  def remember_me
    cookies.permanent[:remember_token] = {
      value: current_user.remember_token,
      httponly: true
    }
  end

  def sign_in_from_cookies
    if cookies[:remember_token].present?
      if user = User.where(remember_token: cookies[:remember_token]).first
        session[:current_user_id] = user.id
        user
      else
        forget_me
        nil
      end
    end
  end

  def forget_me
    cookies.delete(:remember_token)
  end

  def signed_in_required
    unless signed_in?
      store_location

      if is_wechat_browser_request?
        redirect_to wechat_auto_login_url
      else
        redirect_to bind_namespace_user_path(current_namespace), notice: '请先绑定帐号'
      end
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location(url = nil)
    if url
      session[:return_to] = url
    else
      session[:return_to] = request.url if request.get?
    end
  end

  def no_signed_in_required
    if signed_in?
      redirect_to namespace_user_path(current_namespace)
    end
  end
end
