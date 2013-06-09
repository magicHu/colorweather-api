require 'spec_helper'

describe Weather::API do

  def create_version
    Setting.create!(:version => Time.new.to_i.to_s, :download_url => "weather.info/download", :notice => "welcom to colorweather", :is_taobao => true, :tabao_message => "donate", :taobao_url => "taobao.com")
  end

  it "get city weather info by city no" do
    city_no = "101010100"
    get "/v1/weather/city/#{city_no}"
    response.status.should == 200
    weather_info = MultiJson.load(response.body)

    "北京".should == weather_info["current"]["city"]
    city_no.should == weather_info["current"]["cityid"]
    6.should == weather_info["forecasts"].size
  end


  it "get city weather info by city no" do
    city_no = "101320101"
    get "/v1/weather/city/#{city_no}"
    response.status.should == 200
    weather_info = MultiJson.load(response.body)

    "香港".should == weather_info["current"]["city"]
    city_no.should == weather_info["current"]["cityid"]
    6.should == weather_info["forecasts"].size

    "--".should == weather_info["current"]["temp"]
    "--".should == weather_info["current"]["WD"]
    "--".should == weather_info["current"]["WS"]
    "--".should == weather_info["current"]["SD"]
  end

  it "get city weather info by no exist city no" do
    get "/v1/weather/city/noexist"
    response.status.should == 400
  end

  it "get city weather info by lat and lng" do
    lat, lng = 31.196375, 121.4354
    get "/v1/weather/lat/#{lat}/lng/#{lng}"
    response.status.should == 200

    weather_info = MultiJson.load(response.body)
    "上海".should == weather_info["current"]["city"]
    "101020100".should == weather_info["current"]["cityid"]
    6.should == weather_info["forecasts"].size
  end

  it 'create version info' do
    expect_version_info = create_version

    get "/v1/weather/version"
    response.status.should == 200
    version_info = MultiJson.load(response.body)

    expect_version_info.version.should == version_info["version"]
  end

  it 'update version info' do
    expect_version_info = Setting.last
    expect_version_info.update_attribute(:version, expect_version_info.version + ".new")

    get "/v1/weather/version"
    response.status.should == 200
    version_info = MultiJson.load(response.body)
    expect_version_info.version.should == version_info["version"]
  end

end
