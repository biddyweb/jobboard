# So that Scraper.sources below works correctly (note Rails' autoloading)
require_all "#{Rails.root}/lib/scraper"

module Scraper

  def self.run source
    Engine.new(source).scrape
  end

  def self.run_all
    sources.map { |source| { source => run(source) } }.reduce(:merge)
  end

  def self.sources
    # http://stackoverflow.com/questions/833125/find-classes-available-in-a-module
    Scraper.constants.select { |c| Class === Scraper.const_get(c) }
      .select { |klass| "::Scraper::#{klass}".constantize < ::Scraper::Processor }
  end

end
