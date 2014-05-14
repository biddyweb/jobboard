module Scraper 
  # use mechanize to scrape from https://www.poverty-action.org/getinvolved/jobs
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class Gates < Processor

    ORGANIZATION = "The Bill and Melinda Gates Foundation"
    SOURCE = "http://careers.gatesfoundation.org/search/?q=&location"
    LOCATION = "Seattle, WA"

    def initialize
    end

    def scrape agent    # Scrape page for job pages, and then create a job out of each link
      jobs = nil
      agent.get(SOURCE) do |page|                                 # Begin page scraping using Mechanize
        links = page / "tbody" / "a"                              # Use XPATH to get all links within the tbody wrapper from the page
        links = links.to_a                                        # Turn list of links into an array
        jobs = links.map do |link|                                # Scrape a job from each link
          link = link.attributes["href"].to_s                     # Get link from page and convert it to string
          link = "http://careers.gatesfoundation.org" + link      # Gates Foundation uses relative links, so we need to get the full URL
          scrape_job(agent, link)
        end
      end
      jobs.compact
    end

    def scrape_job agent, link                                    # Prep each individual job page
      job = nil
      agent.get(link) do |page|                                   # Scrape page using Mechanize
        content = page / "div.jobDisplay"                         # Get job content from the div jobDisplay wrapper
        job = create_job_from_content! content, link              # Create a job out of it
      end
      job
    end

    def create_job_from_content! content, link                    # Actually put the job in the database
      title = content / "div.jobTitle" / "h1#job-title"           # Grab title object from the job-title h1 tag within the jobTitle div tag
      title = title.children[0].text                              # Grab title text from the title object
      title = title.gsub(' Job', '')                              # Remove "Job" from title

      location = content / "p#job-location"                       # Grab location object from the job-location p tag
      location = location.children[3].children[0].text            # Grab location text from the location object

      startdate = content / "p#job-date"                          # Grab start date object from the job-date p tag
      startdate = startdate.children[3].children[0].text          # Grab location text from the location object
      
      content_t = content / "div.job"                             # Split out all the unnecessary wrapping
      content_t = content_t.to_html                               # Change content from Nokogiri object to HTML
      
      # A check for existence is already present in the scrape method
      Job.new \
        title: title,
        org: ORGANIZATION,
        internship: false,
        postdate: startdate,
        filldate: nil,
        location: location,
        description: content_t,
        link: link,
        user_id: 1
    end

  end

end

