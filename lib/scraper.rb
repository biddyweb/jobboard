require 'mechanize'

class Scraper

  def initialize(source)
    @source = source 
     = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
    }
  end

end
