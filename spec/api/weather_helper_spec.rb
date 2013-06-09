require 'spec_helper'

describe WeatherHelper do
  
  include WeatherHelper

  it "parse city name" do
    expect_city_name = "大连"

    expect_city_name.should == get_city_name("大连")
    expect_city_name.should == get_city_name("辽宁省大连")
    expect_city_name.should == get_city_name("辽宁省大连市")
    expect_city_name.should == get_city_name("辽宁省大连市xx区")
  end

end
