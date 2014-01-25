require 'mechanize'

module Scraper
  class Engine

    def initialize(source)
      @source = "Scraper::#{source}".safe_constantize.new
      @agent = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }
    end

    def scrape
      
      @source.scrape @agent

    end

  end
end
