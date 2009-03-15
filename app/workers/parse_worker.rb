class ParseWorker < Workling::Base
  def parse(options)
    logger.info("about to moo.")
    IrrRealEstate.parse
    puts 'bla'
  end
end
