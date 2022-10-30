require "rails_helper"

RSpec.describe ShortUrl, type: :model do
  context "validations" do
    it "validates presence of original_url" do
      url = ShortUrl.new(short_id: "12345")
      expect(url).to_not be_valid
      expect(url.errors.full_messages).to include("Original url can't be blank")
    end
    it "validates presence of short_id" do
      url = ShortUrl.new(original_url: "http://www.example.com")
      expect(url).to_not be_valid
      expect(url.errors.full_messages).to include("Short can't be blank")
    end

    it "validates url format" do
      url = ShortUrl.new(short_id: "1234567", original_url: "www.example.com")
      expect(url).to_not be_valid
      expect(url.errors.full_messages).to include("Original url url must be a valid HTTP or HTTPS url")
    end

    it "validates url does not point to base" do
      url = ShortUrl.new(short_id: "1234567", original_url: "https://#{ENV['HOST_NAME']}/12334")
      expect(url).to_not be_valid
      expect(url.errors.full_messages).to include("Original url cannot point to #{ENV["HOST_NAME"]}")
    end

    it "validates uniqueness of short_id" do
      ShortUrl.create!(short_id: "1234567", original_url: "https://example.com")
      url = ShortUrl.new(short_id: "1234567", original_url: "https://other-example.com")

      expect(url).to_not be_valid
      expect(url.errors.full_messages).to include("Short has already been taken")
    end

    it "validates uniqueness of short_id" do
      ShortUrl.create!(short_id: "1234567", original_url: "https://example.com")
      url = ShortUrl.new(short_id: "7654321", original_url: "https://example.com")

      expect(url).to_not be_valid
      expect(url.errors.full_messages).to include("Original url has already been taken")
    end
  end

  it "generates display name" do
    url = ShortUrl.new(short_id: "1234567", original_url: "http://www.example.com")
    expect(url.display_name).to eq("http://#{ENV['HOST_NAME']}/1234567")
  end
end
