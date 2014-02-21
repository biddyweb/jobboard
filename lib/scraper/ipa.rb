module Scraper 
  # use mechanize to scrape from https://www.poverty-action.org/getinvolved/jobs
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class IPA < Processor

    ORGANIZATION = 'Innovations for Poverty Action'
    LOCATION = 'New Haven, CT'
    SOURCE = "http://www.poverty-action.org/getinvolved/jobs"

    def initialize
    end

    def scrape agent
      jobs = []
      agent.get(SOURCE) do |page|
        links = page / "div#content" / "a"
        links = links.to_a
        links = links.select do |link|
          link.attributes["href"].to_s =~ /jobs\//
          # Noticed that only legitimate job links have a URL 
          # descriptor with a path after "jobs".
        end
        puts links.map(&:to_html)

        #  $link.methods - Class.new.methods

=begin

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
=end
      end
      jobs.compact
    end

    def create_job_from_xml! xml
      unless Job.where('title like ?', "%#{xml[0].text}%")
                .where(org: ORGANIZATION).exists? # TODO: Move to Engine
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

