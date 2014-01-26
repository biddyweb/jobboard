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
      jobs = @source.scrape @agent
      return 0 unless jobs
      jobs.each(&:save)
      jobs.count
    end

  end
end
