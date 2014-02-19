module Scraper 
  # use mechanize to scrape from http://80000hours.org/recruitment
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class HumaneLeagueJobs < Processor

    ORGANIZATION = 'The Humane League'
    LOCATION = 'United States'
    SOURCE = "http://www.thehumaneleague.com/jobs.htm"

    def initialize
    end

    def scrape agent
      jobs = []
      agent.get(SOURCE) do |page|

        jobs_div = page / 'BOC'
        buffer = []
        print jobs_div[1]
        for child in jobs_div[1].children
          if child.name == 'strong class="style16"'
            jobs << create_job_from_xml!(buffer)
            buffer = []
          end
          buffer << child
        end
      end
      jobs.compact
    end

    def create_job_from_xml! xml
      unless Job.where('title like ?', "%#{xml[0].text}%")
                .where(org: ORGANIZATION).exists? # TODO: Move to Engine
        Job.new \
          title: xml[0].text,
          org: ORGANIZATION,
          internship: False,
          postdate: nil, filldate: nil, # Doesn't appear to be shown...
          location: LOCATION,
          description: xml[1..-1].map(&:to_html).join,
          link: SOURCE,
          user_id: 1
      end
    end
  end
end

