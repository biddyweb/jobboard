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
        print page
      end
    end
  end
end

