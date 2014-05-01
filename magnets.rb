#!/usr/bin/env ruby

require 'bundler/setup'
require 'etc'
require 'pathname'
require 'nokogiri'
require 'net/http'
require 'data_mapper'
require 'open-uri'

class Track < Struct.new(:author, :title, :shazam_id)

  class << self
    def list_from_file download_file
      ids = []

      doc = Nokogiri::HTML(File.open(download_file, "r:utf-8"))
      doc.xpath("//table/tr").map.with_index do |tr, i|
        next if i == 0  # Skip header

        # Find shazam id, don't parse return duplicates
        link = tr.xpath("./td/a").first
        shazam_id = Regexp.last_match[1].to_i if link.attributes["href"].to_s.strip =~ /t(\d+)$/
        if ids.include? shazam_id; next; else ids.push(shazam_id); end

        Track.new(
          tr.children.first.content.to_s.strip, # Title
          tr.xpath("./td[position()=2]").first.content.to_s.strip, # Author
          shazam_id
        )
      end.compact
    end
  end

  def to_s
    [self.author, self.title].compact.join(" ").strip
  end

  def magnet_from_piratebay
    begin
      search_url = "http://thepiratebay.se/search/%s" % URI::encode(to_s)
      doc = Nokogiri::HTML open(search_url)
      doc.xpath("//a[starts-with(@href,'magnet')]").first.attributes["href"].to_s
    rescue
      nil
    end
  end

  def magnet
    @magnet ||= magnet_from_piratebay
  end

end

# Cry if no download_file
unless File.exist?(download_file = ARGV[0].strip)
  $stderr.puts "Error: Please specify path to \"myshazam-history.html\"!"
  exit 1
end

# # DataMapper
# database_path = ENV["MYSHAZAM_DB"] || "sqlite://#{Pathname.new(Etc.getpwuid.dir).join("myshazam.db")}"
# $stdout.puts "Database: #{database_path}"
# DataMapper.setup(:default, database_path)
# DataMapper.finalize
# DataMapper.auto_upgrade!

# # Destination folder
# download_folder = ARGV[1] || ENV["MYSHAZAM_MUSIC"] || Pathname.new(Etc.getpwuid.dir).join("Music", "MyShazam")
# $stdout.puts "Destination: #{download_folder}"
# unless Dir.exists? download_folder
#   $stdout.puts "Error: Missing folder: #{download_folder}"
#   exit 1
# end

tracks = Track.list_from_file download_file
tracks.each do |track|
  next if track.magnet.nil?
  $stdout.puts track.magnet
end
