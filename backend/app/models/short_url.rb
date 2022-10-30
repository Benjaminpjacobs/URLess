require 'uri'

class ShortUrl < ApplicationRecord;
  validates :original_url, presence: true, uniqueness: true
  validates :short_id, presence: true, uniqueness: true

  validate :is_valid_url
  validate :is_not_host

  def is_valid_url
    uri = URI.parse(self.original_url)
    unless uri.is_a?(URI::HTTP) && !uri.host.nil?
      self.errors.add(:original_url, "url must be a valid HTTP or HTTPS url")
      return false
    end
    true
  rescue URI::InvalidURIError
    self.errors.add(:original_url, "url must be a valid HTTP or HTTPS url")
    false
  end

  def is_not_host
    return unless is_valid_url

    uri = URI.parse(self.original_url)
    if uri.host.match(ENV["HOST"]) && uri.port.to_s == ENV["PORT"]
      self.errors.add(:original_url, "cannot point to #{ENV["HOST_NAME"]}")
    end
  end

  def display_name
    "http://#{ENV["HOST_NAME"]}/#{self.short_id}"
  end
end
