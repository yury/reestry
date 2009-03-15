class ParsersController < ApplicationController
  def irr
  end

  def start_irr
    ParseWorker.asynch_parse

    respond_to do |format|
      format.xml # new.html.erb
      format.html  { render :text => "Starting..." }
    end
  end

end
