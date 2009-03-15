require 'rake'

namespace :parse do

  desc "parses irr"
  task :irr => :environment  do
    irr_url = ENV["irr_url"]

    IrrRealEstate.parse
  end
end