task test: [:environment] do
  puts "Running Test Suite:\n\n"
  system "bundle exec rspec --format documentation"
end
