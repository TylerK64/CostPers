class ApiController < ActionController::Base
  def require_login
    authenticate_token || render_unauthorized("Invalid user")
  end

  def current_user
    @current_user ||= authenticate_token
  end

  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  private

  def authenticate_token
    p params
    User.find_by(token: params[:token])
    # authenticate_with_http_token do |token, options|
    #   User.find_by(token: token)
    # end
  end
end