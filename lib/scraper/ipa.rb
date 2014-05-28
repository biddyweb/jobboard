module Scraper 
  # use mechanize to scrape from https://www.poverty-action.org/getinvolved/jobs
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class IPA < Processor

    ORGANIZATION = "Innovations for Poverty Action"
    SOURCE = "http://www.poverty-action.org/getinvolved/jobs"
    LOCATION = "New Haven, CT"

    def initialize
    end

    def scrape agent    # Scrape page for job pages, and then create a job out of each link
      jobs = nil
      agent.get(SOURCE) do |page|                             # Begin page scraping using Mechanize
        links = page / "div#content" / "a"                    # Use XPATH to get all links within the div content wrapper from the page
        links = links.to_a                                    # Turn list of links into an array
        links = links.select do |link|                        # The first link is a javascript action, which we want to get rid of...
          link.attributes["href"].to_s =~ /jobs\//            # ...noticed that only legitimate job links have a URL descriptor with a path after "jobs", so we use regex.
        end
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
        content = page / "div#content"                            # Get page content from the div content wrapper
        job = create_job_from_content! content, link              # Create a job out of it
      end
      job
    end

    def create_job_from_content! content, link                    # Actually put the job in the database
      title = content / "h1.title"                                # Grab title from content
      title = title.text.gsub(/\((.+)\)/, '')                     # Get title and regex out the location
      
      content_t = content.to_html                                 # Change content from Nokogiri object to HTML
      content_t.gsub!(/\<h1(.+)\<\/h1\>/m, '')                    # Remove title from description
      content_t.gsub!(/\<ul class\=\"links(.+)\<\/div\>/m, '')    # Remove "Print this page" and "Share" links from description

      # Remove annoying styling
      p1style = "color: rgb(57, 57, 57); line-height: 1.5em; margin: 0px 0px 1em; font-family: Helvetica, Arial, 'Nimbus Sans L', sans-serif; font-size: 14px; background-color: rgb(255, 255, 255);"
      p2style = "color: rgb(57, 57, 57); line-height: 18pt; margin: 0px 0px 12pt; font-family: Helvetica, Arial, 'Nimbus Sans L', sans-serif; font-size: 14px; background-color: white;"
      ulstyle = "color: rgb(57, 57, 57); line-height: 1.5em; margin: 1em 0px; padding-left: 2em; font-family: Helvetica, Arial, 'Nimbus Sans L', sans-serif; font-size: 14px; background-color: rgb(255, 255, 255);"
      span1style = "font-size: 10.5pt; font-family: Helvetica, sans-serif;"
      span2style = "color: rgb(57, 57, 57); font-family: Helvetica, Arial, 'Nimbus Sans L', sans-serif; font-size: 14px; line-height: 20.400001525878906px; background-color: rgb(255, 255, 255);"
      content_t.gsub!('<p style="' + p1style + '">', "<p>")
      content_t.gsub!('<p style="' + p2style + '">', "<p>")
      content_t.gsub!('<ul style="' + ulstyle + '">', "<ul>")
      content_t.gsub!('<span style="' + span1style + '">', "<span>")
      content_t.gsub!('<span style="' + span2style + '">', "<span>")


      # Grab information from ul elements on page
      list_els = content / "li"
      list_loc = list_els.select { |li| em = li / "strong"; em.try(:first).try(:text) =~ /Location/ }               # Grab location
      location = list_loc.try(:first).try(:children).try(:[], 1).try(:text).try(:strip) # (One might think we could just get the location from the title capture group
                                                                                        # included above, but not all locations appear in the title on the page.)

      list_start = list_els.select { |li| em = li / "strong"; em.try(:first).try(:text) =~ /Desired start date/ }   # Grab start date
      startDate = list_start.try(:first).try(:children).try(:[], 1).try(:text).try(:strip)

      
      # A check for existence is already present in the scrape method
      Job.new \
        title: title,
        org: ORGANIZATION,
        internship: false,
        postdate: nil,
        filldate: startDate,
        location: location,
        description: content_t,
        link: "http://www.poverty-action.org" + link,
        user_id: 1
    end

  end

end

