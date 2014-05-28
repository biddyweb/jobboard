module Scraper 
  # use mechanize to scrape from PSI
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class PSI < Processor

    ORGANIZATION = "Population Services International"
    SOURCE = "http://hire.jobvite.com/CompanyJobs/Careers.aspx?k=JobListing&c=qju9VfwB&jvresize=http%3a%2f%2fwww.psi.org%2fsites%2fdefault%2fthemes%2fpsi%2fFrameResize.html&v=1"
    LOCATION = "Washington DC, USA"

    def initialize
    end

    def scrape agent    # Scrape page for job pages, and then create a job out of each link
      jobs = nil
      agent.get(SOURCE) do |page|                                               # Begin page scraping using Mechanize
        links = page / "div.jvlisting" / "a"                                    # Use XPATH to get all links within the jvlisting div wrapper from the page
        links = links.to_a                                                      # Turn list of links into an array
        4.times { links.shift }                                                 # Throw out first four links (not job related)
        jobs = links.map do |link|                                              # Scrape a job from each link
          next if Job.where(title: link.text).where(org: ORGANIZATION).exists?
          middle_man(agent, link.attributes["href"].to_s)
        end
      end
      jobs.compact
    end

    # PSI uses a really annoying frame, so we need to get the frame and then find the real job content there
    def middle_man agent, link
      job = nil
      agent.get(link) do |page|
        url = page / "div#node-5647"                                            # Grab frame, which is wrapped in the node-5647 div tag
        url = url.children[3]['src']                                            # Grab URL out of frame
        flag = link.gsub('http://www.psi.org/jobs/all-positions?jvi=', '')      # We need to get the job id out of the URL and pass it along in order to get the frame right.
        url = url + '&j=' + flag                                                # Append the flag to the URL 
        job = scrape_job(agent, url, link)                                      # Get the job from the frame URL.  Also pass original link so we can keep it for records.
      end
      job
    end

    def scrape_job agent, link, original                                        # Prep each individual job page
      job = nil
      agent.get(link) do |page|                                                 # Scrape page using Mechanize
        content = page / "div.jvdescription"                                    # Get job content from the div jvdescription wrapper
        job = create_job_from_content! content, link, original                  # Create a job out of it
      end
      job
    end

    def create_job_from_content! content, link, original                        # Actually put the job in the database
      title = content / "div.jvjobheader" / "h2"                                # Grab title object from the h2 tag within the jvjobheader div tag
      title = title.text                                                        # Grab title text from the title object

      location = content / "div.jvjobheader" / "h3"                             # Grab location object from the h3 tag within the jvjobheader div tag
      location = location.text                                                  # Grab location text from the location object
      location.gsub!(/^[^|]*|/, '').slice!(0)                                   # Remove extraneous text from location (everything up to the space after the pipe character)
      
      content_t = content / "div.jvdescriptionbody"                             # Split out all the unnecessary wrapping
      content_t = content_t.to_html                                             # Change content from Nokogiri object to HTML
      
      # A check for existence is already present in the scrape method
      Job.new \
        title: title,
        org: ORGANIZATION,
        internship: !!(title =~ /intern/i),
        postdate: nil,
        filldate: nil,
        location: location,
        description: content_t,
        link: original,
        user_id: 1
    end

  end

end

