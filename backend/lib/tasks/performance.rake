require "benchmark"
require 'net/http'

namespace :performance do
  task create: [:environment] do
    # REQUESTS=25 rails performance:post
    limit = ENV.fetch("REQUESTS", 10)
    puts "Preparing to run benchmark with #{limit} requests\n\n"

    urls = limit.times.map do |i|
      "http://www.example.com/#{i}"
    end

    Benchmark.bmbm do |x|
      x.report("#{limit} Requests") do
        urls.each do |url| 
          `curl -X POST -s -o /dev/null -H "Content-Type: application/json" -d '{"url": { "original_url": "#{url}" } }' http://localhost:3000`
        end
      end
    end
    Rails.application.eager_load!
    ShortUrl.where(original_url: urls).destroy_all
  end

  task redirect: [:environment] do
    # REQUESTS=25 rails performance:redirect
    puts "Clearing cache..."
    Rails.cache.clear

    limit = ENV.fetch("REQUESTS", 10)
    puts "Preparing to run benchmark with #{limit} requests\n\n"

    Rails.application.eager_load!
    short_ids = ShortUrl.limit(limit).pluck(:short_id)

    Benchmark.bmbm do |x|
      x.report("#{limit} Requests") do
        short_ids.each { |short_ids| `curl http://localhost:3000/#{short_ids} -s -o  /dev/null`}
      end
    end
  end
end


