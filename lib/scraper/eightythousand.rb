module Scraper 

  class Eightythousand < Processor

    def initialize
    end

    def scrape(agent)
      jobs = []
      agent.get("http://80000hours.org/recruitment") do |page|

        h2s = page / "div.col-md-9"
        buffer = []
        for child in h2s[1].children
          if child.name == "h2"
            jobs << buffer 
            flag = true
          end
          buffer << child

        end
        
        return jobs
      end
      jobs
    end
      

  end

end

