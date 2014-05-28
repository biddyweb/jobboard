#encoding: UTF-8
# http://stackoverflow.com/questions/16045117/how-do-i-fix-an-invalid-multibyte-character-in-regex

module Scraper 
  # use mechanize to scrape from https://www.poverty-action.org/getinvolved/jobs
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class Farmsanctuary < Processor

    ORGANIZATION = "Farm Sanctuary"
    SOURCE = "http://www.farmsanctuary.org/get-involved/jobs-intern-volunteer/jobs/current-job-listings/"
    LOCATION = "Watkins Glen, NY"

    def initialize
    end

    def scrape agent    # Scrape page for job pages, and then create a job out of each link
      jobs = nil
      agent.get(SOURCE) do |page|                             # Begin page scraping using Mechanize
        links = page / "div.entry-content" / "a"               # Use XPATH to get all links within the div entry-content wrapper from the page
        links = links.to_a                                    # Turn list of links into an array
        jobs = links.map do |link|                            # Scrape a job from each link
          next if Job.where(title: link.text).where(org: ORGANIZATION).exists?
          scrape_job(agent, link.attributes["href"].to_s)
        end
      end
      jobs.compact
    end

    def scrape_job agent, link                                    # Prep each individual job page
      job = nil
      agent.get(link) do |page|                                   # Scrape page using Mechanize
        content = page / "div.entry-content"                      # Get page content from the div entry-content wrapper
        job = create_job_from_content! content, link              # Create a job out of it
      end
      job
    end

    def create_job_from_content! content, link                    # Actually put the job in the database
      title = content / "h2"                                      # Grab title from content
      title = title.text                                          # Get text from Nokogiri object
      if title.include? "—"                                       # If the title has a dash, it will have a location that needs to be (a) stripped out and (b) stored
        title = title.gsub(/\—(.+)/, '')[0..-2]                   # Get title and regex out the location
        location = $1[1..-1]                                      # Get location via the regex capture group we just defined
      else
        location = LOCATION                                       # No dash means no location to store, so assume default location
      end

      content_t = content.to_html                                           # Change content from Nokogiri object to HTML
      content_t.gsub!(/<h2 style\=\"text-align: center;\">.+<\/h2>/, '')    # Strip out title tag
      
      # A check for existence is already present in the scrape method
      Job.new \
        title: title,
        org: ORGANIZATION,
        internship: false,
        postdate: nil,
        filldate: nil,
        location: location,
        description: content_t,
        link: link,
        user_id: 1
    end

  end

end

