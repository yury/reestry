class SitemapController < ApplicationController
  def sitemap
    @entries = Realty.find(:all, :order => "updated_at DESC", :limit => 50000,
                           :conditions => ["expire_at >= now()"])
    headers["Content-Type"] = "application/xml"
    # set last modified header to the date of the latest entry.
    headers["Last-Modified"] = @entries[0].updated_at.httpdate if !@entries.nil?

    render :layout => false
  end
end
