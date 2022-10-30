require "rails_helper"

RSpec.describe ShortUrlCreationService, type: :service do
  let(:url) { "http://www.example.com" }

  describe('.call') do
    subject { ShortUrlCreationService.call(original_url: url) }

    it "returns a short url hash for url string" do
      service = subject

      expect(service.success?).to be true
      expect(service.errors).to be_empty
      expect(service.short_url).to be_a(ShortUrl)
      expect(service.short_url.short_id).to match(/[a-zA-Z\d]/)
      expect(service.short_url.short_id.length).to eq(11)
    end

    it "returns errors if cannot generate a unique id" do
      allow(ShortUrl).to receive(:exists?).exactly(described_class::MAX_UNIQUE_GENERATION).times.and_return(true)

      service = subject

      expect(service.success?).to be false
      expect(service.errors).to include("could not generate unique id")
      expect(service.short_url).to be_nil
    end

    it "returns model errors if they exist" do
      errors_double = double(
        "errors",
        {
          full_messages: ["unexpected model error"],
          clear: true,
          empty?: false
        }
      )

      allow_any_instance_of(ShortUrl).to receive(:errors).and_return(errors_double)

      service = subject

      expect(service.success?).to be false
      expect(service.errors).to include("unexpected model error")
      expect(service.short_url).to_not be_nil
    end

    context "short url exists for original" do
      let!(:existing) { ShortUrl.create!(original_url: url, short_id: SecureRandom.urlsafe_base64(9).chop ) }

      it "returns the existing short url" do
        service = subject

        expect_any_instance_of(ShortUrlCreationService).to_not receive(:generate_unique_short_id)
        expect(ShortUrl).to_not receive(:create)

        expect(service.success?).to be true
        expect(service.errors).to be_empty
        expect(service.short_url).to eq(existing)
      end
    end
  end
end
