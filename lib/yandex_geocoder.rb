#encoding: utf-8
require "geokit"

module Geokit
  module Inflector
    def url_escape(s)
      s.to_s.dup.force_encoding("ASCII-8BIT").gsub(/[^a-zA-Z0-9_\-.]/n) {
        sprintf("%%%02X", $&.unpack("C")[0])
       }
    end
  end

  module Geocoders

    @@yandex = 'REPLACE_WITH_YOUR_YANDEX_KEY'
    __define_accessors

    class GoogleGeocoder < Geokit::Geocoders::Geocoder
      def self.do_geocode(address, options = {})
        bias_str = options[:bias] ? construct_bias_string_from_options(options[:bias]) : ''
        address_str = address.is_a?(GeoLoc) ? address.to_geocodeable_s : address
        res = self.call_geocoder_service("http://maps.google.com/maps/geo?q=#{Geokit::Inflector::url_escape(address_str)}&output=xml#{bias_str}&key=#{Geokit::Geocoders::google}&oe=utf-8")
        return GeoLoc.new if !res.is_a?(Net::HTTPSuccess)
        xml = res.body
        xml = xml.force_encoding(Encoding::UTF_8) if xml.respond_to?(:force_encoding)
        logger.debug "Google geocoding. Address: #{address}. Result: #{xml}"
        return self.xml2GeoLoc(xml, address)
      end
    end

    class YandexGeocoder < Geokit::Geocoders::Geocoder

      @@country_mappings = {
              'Россия' => 'RU',
              'США' => 'US',
              'Великобритания' => 'GB',
              'Беларусь' => 'BY',
              'Украина' => 'UA',
              #TODO: add countries
      }

      private

# Template method which does the geocode lookup.
      def self.do_geocode(address, options = {})
        address_str = address.is_a?(GeoLoc) ? address.to_geocodeable_s : address
        url="http://geocode-maps.yandex.ru/1.x/?key=#{Geokit::Geocoders::yandex}&geocode=#{Geokit::Inflector::url_escape(address_str)}"
        res = self.call_geocoder_service(url)
        return GeoLoc.new if !res.is_a?(Net::HTTPSuccess) && !res.is_a?(Net::HTTPMovedPermanently)

        xml = res.body
        doc = REXML::Document.new(xml)
        logger.debug "Yandex geocoding. Address: #{address}. Result: #{xml}"

        if doc.elements['//GeocoderResponseMetaData/found'].text.to_i != 0
          res=GeoLoc.new

          loc = doc.elements['//GeoObject']

          #basic
          res.full_address = loc.elements['.//text'].text
          res.lng, res.lat = loc.elements['.//Point/pos'].text.split(' ')
          res.country_code = @@country_mappings[loc.elements['.//CountryName'].text]
          res.provider='yandex'

#extended - false if not available
          res.city=loc.elements['.//LocalityName'].text if loc.elements['.//LocalityName'] && loc.elements['.//LocalityName'].text != nil
          res.state=loc.elements['.//AdministrativeAreaName'].text if loc.elements['.//AdministrativeAreaName'] && loc.elements['.//AdministrativeAreaName'].text != nil
          res.street_address=loc.elements['.//ThoroughfareName'].text if loc.elements['.//ThoroughfareName'] && loc.elements['.//ThoroughfareName'].text != nil
          res.accuracy=loc.elements['.//precision'].text if loc.elements['.//precision'] && loc.elements['.//precision'].text != nil
          res.suggested_bounds = Bounds.normalize(loc.elements['.//Envelope/lowerCorner'].text.split(' ').reverse, loc.elements['.//Envelope/upperCorner'].text.split(' ').reverse)
          res.success=true
          return res
        else
          logger.info "Yandex was unable to geocode address: "+address
          return GeoLoc.new
        end

      rescue
        logger.info "Caught an error during Yandex geocoding call: "+$!
        return GeoLoc.new
      end
    end
  end
end