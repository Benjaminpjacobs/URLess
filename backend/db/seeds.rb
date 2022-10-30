require 'csv'

puts "Seeding local db"

loading_indicator = "[" + "".ljust(50) + "]\r"
print loading_indicator

CSV.foreach(Rails.root.join('db', 'url_list.csv'), headers: true, header_converters: :symbol).each_with_index do |row, idx|
  ShortUrlCreationService.call(original_url: "http://#{row[:root_domain]}")

  # Print loading indicator
  if idx % 10 == 0 && idx != 0
    count = idx/10
    chars  = "#"*count
    print "[" + chars.ljust(50) + "]\r"
  end
end
puts "\n#{ShortUrl.count} short url records seeded!"

