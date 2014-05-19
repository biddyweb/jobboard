module Scraper 
  # use mechanize to scrape from https://www.poverty-action.org/getinvolved/jobs
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class PSI < Processor

    ORGANIZATION = "Population Services International"
    SOURCE = "http://hire.jobvite.com/CompanyJobs/Careers.aspx?k=JobListing&c=qju9VfwB&jvresize=http%3a%2f%2fwww.psi.org%2fsites%2fdefault%2fthemes%2fpsi%2fFrameResize.html&v=1"
    LOCATION = "Washington DC, USA"

    def initialize
    end

    def scrape agent    # Scrape page for job pages, and then create a job out of each link
      jobs = nil
      agent.get(SOURCE) do |page|                                 # Begin page scraping using Mechanize
        links = page / "div.jvlisting" / "a"                      # Use XPATH to get all links within the jvlisting div wrapper from the page
        links = links.to_a                                        # Turn list of links into an array
        4.times { links.shift }                                   # Throw out first four links (not job related)
        jobs = links.map do |link|                                # Scrape a job from each link
          next if Job.where(title: link.text).where(org: ORGANIZATION).exists?
          middle_man(agent, link.attributes["href"].to_s)
        end
      end
      jobs.compact
    end

    def middle_man agent, link                                    # PSI uses an annoying frame, so we need to get the frame and then find the real job content there
      agent.get(link) do |page|
        content = page / "frame#jobviteframe"                     # Grab frame (not sure this works)
        raise content.inspect
      end
      scrape_job(agent, link)
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

