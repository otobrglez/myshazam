require "myshazam/version"

module Myshazam

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

end
