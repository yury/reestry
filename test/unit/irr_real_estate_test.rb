require 'test_helper'

class IrrRealEstateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_parse_rent
    IrrRealEstate.parse_rent
  end

  def test_parse_page
    IrrRealEstate.parse_page("rent", 1)
  end

  def test_parse_advert
    IrrRealEstate.parse_advert("/advert/21554164/")
  end
end
