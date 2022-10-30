class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :reder_404
  rescue_from StandardError, with: :render_500

  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join('public/404.html'), status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def render_500
    respond_to do |format|
      format.html { render file: Rails.root.join('public/500.html'), status: :internal_server_error }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end
