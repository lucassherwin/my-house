class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  rescue_from ActionController::InvalidAuthenticityToken do
    Rails.logger.warn "InvalidAuthenticityToken: #{e.message}"
    render json: { error: "Session expired - please refresh the page" }, status: :unprocessable_entity
  end

  private

  def current_person
    # test asdfasdfasdf
    return @current_person if defined?(@current_person)

    @current_person = session[:person_id] && Person.find_by(id: session[:person_id])
  end

  helper_method :current_person

  def require_authentication
    redirect_to login_path unless current_person
  end
end
