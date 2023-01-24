require 'onix/product_contact'
require 'onix/sales_rights'
require 'onix/copyright_statement'
require 'onix/date'

module ONIX
  class PublishingDetail < SubsetDSL
    elements "Imprint", :subset, :cardinality => 0..n
    elements "Publisher", :subset, :cardinality => 0..n
    element "CityOfPublication", :text, :shortcut => :city, :cardinality => 0..n
    element "CountryOfPublication", :text, :shortcut => :country, :cardinality => 0..1
    elements "ProductContact", :subset, :cardinality => 0..n
    element "PublishingStatus", :subset, :shortcut => :status, :cardinality => 0..1
    elements "PublishingStatusNote", :text, :cardinality => 0..n
    elements "PublishingDate", :subset, :cardinality => 0..n
    element "LatestReprintNumber", :integer, :cardinality => 0..1
    elements "CopyrightStatement", :subset, :cardinality => 0..n
    elements "SalesRights", :subset, :pluralize => false, :cardinality => 0..n
    element "ROWSalesRightsType", :subset, :klass => "SalesRightsType", :cardinality => 0..1
    element "SalesRestriction", :subset, :cardinality => 0..n

    # @!group High level

    # @return [Publisher]
    def publisher
      main_publishers = @publishers.select { |p| p.role.human == "Publisher" }
      return nil if main_publishers.empty?
      if main_publishers.length == 1
        main_publishers.first
      else
        raise ExpectsOneButHasSeveral, main_publishers.map(&:name)
      end
    end

    # @return [Imprint]
    def imprint
      if @imprints.length > 0
        if @imprints.length == 1
          @imprints.first
        else
          raise ExpectsOneButHasSeveral, @imprints.map(&:name)
        end
      end
    end

    # date of publication
    # @return [Date]
    def publication_date
      pub = @publishing_dates.publication.first
      if pub
        pub.date
      end
    end

    # date of embargo
    # @return [Date]
    def embargo_date
      pub = @publishing_dates.embargo.first
      if pub
        pub.date
      end
    end

    # @return [Date]
    def preorder_embargo_date
      pub = @publishing_dates.preorder_embargo.first
      if pub
        pub.date
      end
    end

    # @return [Date]
    def public_announcement_date
      pub = @publishing_dates.public_announcement.first
      if pub
        pub.date
      end
    end

    # @!endgroup

  end
end
