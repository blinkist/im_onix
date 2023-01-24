require 'onix/sales_rights'
require 'onix/date'
module ONIX
  class PublishingDetail < SubsetDSL
    elements "Imprint", :subset
    elements "Publisher", :subset
    element "CityOfPublication", :text
    element "CountryOfPublication", :text
    element "PublishingStatus", :subset
    elements "PublishingDate", :subset
    elements "SalesRights", :subset, {:pluralize=>false}
    element "ROWSalesRightsType", :subset, {:klass=>"SalesRightsType"}
    element "SalesRestriction", :subset

    def publisher
      main_publishers = @publishers.select { |p| p.role.human=="Publisher" }
      return nil if main_publishers.empty?
      if main_publishers.length == 1
        main_publishers.first
      else
        raise ExpectsOneButHasSeveral, main_publishers.map(&:name)
      end
    end

    def imprint
      if @imprints.length > 0
        if @imprints.length==1
          @imprints.first
        else
          raise ExpectsOneButHasSeveral, @imprints.map(&:name)
        end
      else
        nil
      end
    end

    def publication_date
      pub=@publishing_dates.publication.first
      if pub
        pub.date
      else
        nil
      end
    end

    def embargo_date
      pub=@publishing_dates.embargo.first
      if pub
        pub.date
      else
        nil
      end
    end

    def preorder_embargo_date
      pub=@publishing_dates.preorder_embargo.first
      if pub
        pub.date
      else
        nil
      end
    end

    def public_announcement_date
      pub=@publishing_dates.public_announcement.first
      if pub
        pub.date
      else
        nil
      end
    end

    def status
      @publising_status
    end

    def city
      @city_of_publication
    end

    def country
      @country_of_publication
    end

  end
end
