module Scraper

  SOURCES = ["Eightythousand"]

  def self.run source
    Engine.new(source).scrape
  end

  def self.run_all
    SOURCES.map { |source| { source => run(source) } }.reduce(:merge)
  end

end
