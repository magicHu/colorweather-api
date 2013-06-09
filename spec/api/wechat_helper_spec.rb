require 'spec_helper'

describe WechatHelper do
  
  include WechatHelper

  it "parse temp" do
    # "19℃~33℃"
    "19/33℃".should == parse_temp("19℃~33℃")
  end

  it "parse date" do
    date = Time.now
    date.strftime("%Y年%m月%d日").should == parse_date(date)
  end

  it "parse week" do
    puts parse_week(Time.now)
  end
end
