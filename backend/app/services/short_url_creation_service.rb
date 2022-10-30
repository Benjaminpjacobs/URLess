class ShortUrlCreationService
  MAX_UNIQUE_GENERATION = 3

  class << self
    def call(original_url: original_ur)
      new(original_url).call
    end
  end

  attr_reader :original_url, :short_url, :errors

  def initialize(original_url)
    @original_url = original_url
    @short_url    = existing_short_url
    @success      = false
  end

  def call
    if short_url.present?
      @success = true
      return self
    end

    unique_short_id = generate_unique_short_id

    if unique_short_id.present?
      @short_url = ShortUrl.create(short_id: unique_short_id, original_url: original_url)
    end

    @success = short_url.present? && errors.empty?
    return self
  end

  def success?
    @success
  end

  def errors
    @errors ||= short_url&.errors.full_messages
  end

  private

  def existing_short_url
    ShortUrl.find_by(original_url: original_url)
  end

  def generate_unique_short_id
    generated_unique_id = nil
    iteration           = 0

    until generated_unique_id.present? || iteration >= MAX_UNIQUE_GENERATION
      temp_id = SecureRandom.urlsafe_base64(9).chop

      if ShortUrl.exists?(short_id: temp_id)
        iteration += 1
      else
        generated_unique_id = temp_id
      end
    end

    unless generated_unique_id
      @errors = ["could not generate unique id"]
    end

    generated_unique_id
  end
end
