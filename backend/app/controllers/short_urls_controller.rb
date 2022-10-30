class ShortUrlsController < ApplicationController
  def create
    service = ShortUrlCreationService.call(original_url: url_strong_params[:original_url])

    if service.success?
      short_url = service.short_url
      render json: { new_url: short_url.display_name }, status: :created
    else
      render json: {error: service.errors }, status: :bad_request
    end
  end

  def redirect
    original_url = Rails.cache.fetch(params[:short_id]) do
      ShortUrl.find_by(short_id: params[:short_id])&.original_url
    end

    if original_url.present?
      redirect_to original_url, status: 301
    else
      render_404
    end
  end

  private

  def url_strong_params
    params.require(:url).permit(:original_url)
  end
end
