require "rails_helper"

RSpec.describe ShortUrlsController do
  describe "GET redirect" do
    context "success" do
      it "redirects a valid short url with 301" do
        url = ShortUrl.create!(short_id: "1234567", original_url: "http://www.example.com")
        get :redirect, params: { short_id: url.short_id }
        expect(response.status).to eq(301)
        expect(response.body).to match(url.original_url)
      end
    end

    context "error" do
      it "renders a 404 page on an invalid short url" do
        url = ShortUrl.create!(short_id: "1234567", original_url: "http://www.example.com")
        get :redirect, params: { short_id: "9876543" }
        expect(response.status).to eq(404)
      end
    end
  end

  describe "POST create" do
    context "success" do
      it "creates a new short url with a valid original url" do
        post :create, params: { url: { original_url: "http://www.example.com" } }
        last_url = ShortUrl.last
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)['new_url']).to eq("http://localhost:3000/#{last_url.short_id}")
      end
    end

    context "error" do
      it "doesn't create an invalid url" do
        post :create, params: {"url"=>{"original_url"=>"http://localhost:3000"}, "short_url"=>{}}
        last_url = ShortUrl.last
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['error']).to include("Original url cannot point to #{ENV["HOST_NAME"]}")
      end
    end
  end
end
