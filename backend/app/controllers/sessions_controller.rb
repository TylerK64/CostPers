class SessionsController < ApiController
  skip_before_action :require_login, only: [:new, :create], raise: false
  skip_before_action :verify_authenticity_token, only: [:create], raise: false

  def new
  end

  def create
    p 'reached sessions create post request'
    if user = User.valid_login?(params[:email], params[:password])
      allow_token_to_be_used_only_once_for(user)
      send_auth_token_for_valid_login_of(user)
    else
      render_unauthorized("Invalid email or password")
    end
  end

  def destroy
    logout
    head :ok
  end

  private

  def send_auth_token_for_valid_login_of(user)
    render json: {
      user_id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      token: user.token,
      auth: true
    }.to_json
  end

  def allow_token_to_be_used_only_once_for(user)
    user.regenerate_token
  end

  def logout
    current_user.invalidate_token
  end
end
