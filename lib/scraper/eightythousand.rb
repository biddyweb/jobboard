module Scraper 
  # use mechanize to scrape from http://80000hours.org/recruitment
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class Eightythousand < Processor

    ORGANIZATION = '80,000 Hours'
    LOCATION = 'Centre for Effective Altruism, Oxford'
    SOURCE = "http://80000hours.org/recruitment"

    def initialize
    end

    def scrape agent
      jobs = []
      agent.get(SOURCE) do |page|

        jobs_div = page / "div.col-md-9"
        buffer = []
        for child in jobs_div[1].children
          if child.name == "h2"
            jobs << create_job_from_xml!(buffer)
            buffer = []
          end
          buffer << child
        end
        jobs.shift if jobs.length > 0 # Throw away first entry
      end
      jobs.compact
    end

    def create_job_from_xml! xml
      unless Job.where(title: title).where(org: ORGANIZATION).exists?
        Job.new \
          title: xml[0].text,
          org: ORGANIZATION,
          internship: !!(xml[0].text =~ /intern/i),
          postdate: nil, filldate: nil, # Doesn't appear to be shown...
          location: LOCATION,
          description: xml[1..-1].map(&:to_html).join,
          link: extract_link_from_xml(xml),
          user_id: 1
      end
    end

    def extract_link_from_xml xml
      # A little tricky. Loop for <a> elements and extract href attribute
      # of first one containing text 'this form'.
      link = xml.map { |y| y / 'a' }.flatten
        .select { |y| y.text =~ /this form/i }.first
        .try(:attributes).try(:[], "href").try(:value)
      link || SOURCE
    end

  end

end

