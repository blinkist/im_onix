require 'onix/subset'
require 'onix/website'

module ONIX
  class Contributor < SubsetDSL
    element "SequenceNumber", :integer
    element "ContributorRole", :subset
    elements "NameIdentifier", :subset

    element "PersonName", :text
    element "PersonNameInverted", :text

    element "NamesBeforeKey", :text
    element "KeyNames", :text

    element "BiographicalNote", :text
    elements "Website", :subset
    element "ContributorPlace", :subset

    element "CorporateName", :text

    def role
      @contributor_role
    end

    def identifiers
      @name_identifiers
    end

    def place
      @contributor_place
    end

    def name_before_key
      @names_before_key
    end

    # :category: High level
    # flatten person name (firstname lastname)
    def name
      return @person_name if @person_name

      if @key_names
        if @names_before_key
          return "#{@names_before_key} #{@key_names}"
        else
          return @key_names
        end
      end

      @corporate_name
    end

    # :category: High level
    # inverted flatten person name
    def inverted_name
      @person_name_inverted
    end

    # :category: High level
    # biography string with HTML
    def biography
      @biographical_note
    end

    # :category: High level
    # raw biography string without HTML
    def raw_biography
      if self.biography
        Helper.strip_html(self.biography).gsub(/\s+/, " ")
      else
        nil
      end
    end
  end

  class ContributorPlace < SubsetDSL
    element "ContributorPlaceRelator", :subset
    element "CountryCode", :subset

    def relator
      @contributor_place_relator
    end

    def country_code
      @country_code.code
    end
  end
end
