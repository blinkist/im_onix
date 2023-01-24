require 'onix/code'
module ONIX
  class Territory < SubsetDSL
    element "CountriesIncluded", :text, :cardinality => 0..1
    element "RegionsIncluded", :text, :cardinality => 0..1
    element "CountriesExcluded", :text, :cardinality => 0..1
    element "RegionsExcluded", :text, :cardinality => 0..1

    # @!group High level

    # all countries array
    # @return [Array<String>]
    def countries
      countries = []
      if @countries_included
        countries += @countries_included.split(" ")
      end
      if @regions_included
        countries += @regions_included.split(" ").map { |region| self.class.region_to_countries(region) }.flatten.uniq
      end
      if @countries_excluded
        countries -= @countries_excluded.split(" ")
      end
      if @regions_excluded
        countries -= @regions_excluded.split(" ").map { |region| self.class.region_to_countries(region) }.flatten.uniq
      end
      countries.uniq.sort
    end

    # has worldwide rights ?
    # @return [Boolean]
    def worldwide?
      self.class.worldwide?(self.countries)
    end

    # @param [Array<String>] v
    def countries= v
      if (v.uniq & CountryCode.list).length == CountryCode.list.length
        @regions_included = "WORLD"
      else
        @countries_included = v.uniq.join(" ")
      end
    end

    # !@endgroup

    # @param [String] region
    # @return [Array<String>]
    def self.region_to_countries(region)
      case region
      when "WORLD"
        CountryCode.list
      when "ECZ"
        ["AT", "BE", "CY", "EE", "FI", "FR", "DE", "ES", "GR", "IE", "IT",
         "LU", "MT", "NL", "PT", "SI", "SK", "AD", "MC", "SM", "VA", "ME"]
      else
        []
      end
    end

    # @return [Boolean]
    def self.worldwide?(countries)
      (countries & CountryCode.list).length == CountryCode.list.length
    end
  end
end