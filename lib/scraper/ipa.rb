module Scraper 
  # use mechanize to scrape from https://www.poverty-action.org/getinvolved/jobs
  # mechanize: http://mechanize.rubyforge.org/Mechanize.html
	
  class IPA < Processor

    ORGANIZATION = "Innovations for Poverty Action"
    SOURCE = "http://www.poverty-action.org/getinvolved/jobs"

    def initialize
    end

    def scrape agent    # Scrape page for job pages, and then create a job out of each link
      agent.get(SOURCE) do |page|                             # Begin page scraping using Mechanize
        links = page / "div#content" / "a"                    # Use XPATH to get all links within the div content wrapper from the page
        links = links.to_a                                    # Turn list of links into an array
        links = links.select do |link|                        # The first link is a javascript action, which we want to get rid of...
          link.attributes["href"].to_s =~ /jobs\//            # ...noticed that only legitimate job links have a URL descriptor with a path after "jobs", so we use regex.
        end
        links.map! { |link| link.attributes["href"].to_s }    # Get the URL paths from the links
        links.each do |link|                                  # Scrape a job from each link
          scrape_job(agent, link)
        end
      end
    end

    def scrape_job agent, link    # Prep each individual job page
      agent.get(link) do |page|                     # Scrape page using Mechanize
        content = page / "div#content"              # Get page content from the div content wrapper
        create_job_fron_content! content, link      # Create a job out of it
      end
    end

    def create_job_fron_content! content, link  # Actually put the job in the database
      title = content / "h1.title"   # Grab title from content

      # Grab information from ul elements on page
      list_els = content / "li"
      list_loc = list_els.select { |li| em = li / "strong"; em.try(:first).try(:text) =~ /Location/ }   # Grab location
      location = list_loc[0].children[1].text

      list_start = list_els.select { |li| em = li / "strong"; em.try(:first).try(:text) =~ /Desired start date/ }   # Grab start date
      startDate = list_start[0].children[1].text

      
      # Put the job in the database, unless it already exists
      unless Job.where('title like ?', "%#{content.text}")
        .where(org: ORGANIZATION).exists?
      Job.new \
        title: title,
        org: ORGANIZATION,
        internship: False,
        postdate: nil,
        filldate: startDate,
        location: location,
        description: content,
        link: link,
        user_id: 1
      end
    end

  end

end

