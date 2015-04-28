#!/usr/bin/ruby

#
# $1 Begin        Starting number/character
# $2 End          Ending number/character
# $3 Characters   Total number of characters (if any, this is optional)
# 

#
# Config
#

TEMPLATE_URL = "http://spreesource.io/discussions/{{sku}}"
DOWNLOAD_DIR = "tmp"

#
# This is where the magic happens
#

require 'csv'
require 'open-uri'

def fetch_and_save_all(skus)
  @failures = []
  skus.each do |sku|
    url = TEMPLATE_URL.gsub '{{sku}}', sku
    begin
      puts url
      www = open(url).read
    rescue OpenURI::HTTPError
      @failures << sku
    else
      open("#{DOWNLOAD_DIR}/#{sku}.pdf", 'wb') do |file|
        file << open(url).read
      end
    end
  end
  puts "All done! We had #{@failures.length} failures."
  puts @failures if @failures.length > 0
end

if !ARGV[0].nil? and !ARGV[1].nil?
  fetch_and_save_all(ARGV[0] .. ARGV[1])
else
  csv = CSV.read("input.csv")
  csv.collect! { |row|
    row[1]
  }
  fetch_and_save_all(csv)
end