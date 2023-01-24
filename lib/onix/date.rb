module ONIX

  module DateHelper
    attr_accessor :date_format, :date

    def parse_date(n)
      @date_format=DateFormat.from_code("00")
      date_txt=nil
      @date=nil
      n.elements.each do |t|
        case t
          when tag_match("DateFormat")
            @date_format=DateFormat.parse(t)
          when tag_match("Date")
            date_txt=t.text
        end

        if t["dateformat"]
          @date_format = DateFormat.from_code(t["dateformat"])
        end
      end

      code_format=format_from_code(@date_format.code)
      text_format=format_from_string(date_txt)

      format=code_format

      if code_format!=text_format
#        puts "EEE date #{n.text} (#{text_format}) do not match code #{@format.code} (#{code_format})"
        format=text_format
      end

      begin
        if format
          case @date_format.code
            when "00"
              @date=Date.strptime(date_txt, format)
            when "01"
              @date=Date.strptime(date_txt, format)
            when "05"
              @date=Date.strptime(date_txt, format)
            when "14"
              @date=Time.strptime(date_txt, format)
            else
              @date=nil
          end
        end
      rescue
        # invalid date
      end
    end

    def format_from_code(code)
      case code
        when "00"
          "%Y%m%d"
        when "01"
          "%Y%m"
        when "05"
          "%Y"
        when "14"
          "%Y%m%dT%H%M%S%z"
        else
          nil
      end
    end

    def format_from_string(str)
      case str
        when /^\d{4}\d{2}\d{2}T\d{2}\d{2}\d{2}/
          "%Y%m%dT%H%M%S%z"
        when /^\d{4}\-\d{2}\-\d{2}$/
          "%Y-%m-%d"
        when /^\d{4}\d{2}\d{2}$/
          "%Y%m%d"
        when /^\d{4}\d{2}$/
          "%Y%m"
        when /^\d{4}$/
          "%Y"
        else
          nil
      end
    end

    def time
      @date.to_time
    end
  end

  class MarketDate < SubsetDSL
    include DateHelper
    element "Date", :ignore
    element "DateFormat", :ignore
    element "MarketDateRole", :subset

    scope :availability, lambda { human_code_match(:market_date_role, ["PublicationDate","EmbargoDate"])}

    def role
      @market_date_role
    end

    def parse(n)
      super
      parse_date(n)
    end
  end

  class PriceDate < SubsetDSL
    include DateHelper
    element "Date", :ignore
    element "DateFormat", :ignore
    element "PriceDateRole", :subset

    scope :from_date, lambda { human_code_match(:price_date_role, "FromDate")}
    scope :until_date, lambda { human_code_match(:price_date_role, "UntilDate")}

    def role
      @price_date_role
    end

    def parse(n)
      super
      parse_date(n)
    end
  end

  class SupplyDate < SubsetDSL
    include DateHelper
    element "Date", :ignore
    element "DateFormat", :ignore
    element "SupplyDateRole", :subset

    scope :availability, lambda { human_code_match(:supply_date_role, ["ExpectedAvailabilityDate","EmbargoDate"])}

    def role
      @supply_date_role
    end

    def parse(n)
      super
      parse_date(n)
    end
  end

  class PublishingDate < SubsetDSL
    include DateHelper
    element "Date", :ignore
    element "DateFormat", :ignore
    element "PublishingDateRole", :subset

    scope :publication, lambda { human_code_match(:publishing_date_role, ["PublicationDate","PublicationDateOfPrintCounterpart"])}
    scope :embargo, lambda { human_code_match(:publishing_date_role, "EmbargoDate")}
    scope :preorder_embargo, lambda { human_code_match(:publishing_date_role, "PreorderEmbargoDate")}
    scope :public_announcement, lambda { human_code_match(:publishing_date_role, "PublicAnnouncementDate")}

    def role
      @publishing_date_role
    end

    def parse(n)
      super
      parse_date(n)
    end
  end

  class ContentDate < SubsetDSL
    include DateHelper
    element "Date", :ignore
    element "DateFormat", :ignore
    element "ContentDateRole", :subset

    scope :last_updated, lambda { human_code_match(:content_date_role, "LastUpdated")}

    def role
      @content_date_role
    end

    def parse(n)
      super
      parse_date(n)
    end
  end
end
