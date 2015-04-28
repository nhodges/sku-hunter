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

require 'open-uri'

if !ARGV[0].nil? and !ARGV[1].nil?
  @failures = []
  for sku in ARGV[0] .. ARGV[1]
    url = TEMPLATE_URL.gsub '{{sku}}', sku
    begin
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
else
  puts "Requires input of starting and stopping points."
end