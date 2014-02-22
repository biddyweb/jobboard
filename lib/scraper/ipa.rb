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
          link.attributes["href"].to_s =~ /jobs\// # Noticed that only legitimate job links have a URL descriptor with a path after "jobs".
        end
        links.each do
          links.map! { |link| link.attributes["href"].to_s }
          scrape_job(agent, links)
        end
      end
    end

    def scrape_job agent, links
      agent.get(links) do |page|
        job = page / "div#content"
        puts job
        puts "---"
      end
    end
  
  end

end

