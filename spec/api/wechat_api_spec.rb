require 'spec_helper'

describe Wechat::API do
  
  let(:request_body) {
    <<-EOF 
      <xml>
       <ToUserName><![CDATA[colorweather]]></ToUserName>
       <FromUserName><![CDATA[jobs]]></FromUserName> 
       <CreateTime>1348831860</CreateTime>
       <MsgType><![CDATA[text]]></MsgType>
       <Content><![CDATA[辽宁省大连市]]></Content>
       <MsgId>1234567890123456</MsgId>
     </xml>
    EOF
  }

  let(:location_request_body) {
    <<-EOF 
      <xml>
        <ToUserName><![CDATA[colorweather]]></ToUserName>
        <FromUserName><![CDATA[jobs]]></FromUserName> 
        <CreateTime>1348831860</CreateTime>
        <MsgType><![CDATA[location]]></MsgType>
        <Location_X>23.134521</Location_X>
        <Location_Y>113.358803</Location_Y>
        <Scale>20</Scale>
        <Label><![CDATA[位置信息]]></Label>
        <MsgId>1234567890123456</MsgId>
     </xml>
    EOF
  }

  let(:noexist_city_request_body) {
    <<-EOF 
      <xml>
       <ToUserName><![CDATA[colorweather]]></ToUserName>
       <FromUserName><![CDATA[jobs]]></FromUserName> 
       <CreateTime>1348831860</CreateTime>
       <MsgType><![CDATA[text]]></MsgType>
       <Content><![CDATA[天朝]]></Content>
       <MsgId>1234567890123456</MsgId>
     </xml>
    EOF
  }

  it "get city info from weixin" do
    post "/v1/weixin", request_body
    response.status.should == 200

    puts response.body
    node = Nokogiri::XML(response.body).xpath('//xml')
    "jobs".should == node.xpath('ToUserName').text
    "colorweather".should == node.xpath('FromUserName').text
    "news".should == node.xpath('MsgType').text
    
    today_weather_info = node.xpath('Articles/item')
    city_name = today_weather_info.xpath("Title").text
    city_name.start_with?("大连").should be_true
  end

  it "get city weather by location" do
    post "/v1/weixin", location_request_body
    response.status.should == 200

    puts response.body
    node = Nokogiri::XML(response.body).xpath('//xml')
    "jobs".should == node.xpath('ToUserName').text
    "colorweather".should == node.xpath('FromUserName').text
    "news".should == node.xpath('MsgType').text
    
    today_weather_info = node.xpath('Articles/item')
    city_name = today_weather_info.xpath("Title").text
    city_name.start_with?("广州").should be_true
  end

  it "get no exist city weather info" do
    post "/v1/weixin", noexist_city_request_body
    response.status.should == 200

    node = Nokogiri::XML(response.body).xpath('//xml')
    "jobs".should == node.xpath('ToUserName').text
    "colorweather".should == node.xpath('FromUserName').text
    "text".should ==  node.xpath('MsgType').text
    "请直接输入城市名称，比如: 北京，上海，大连；也可以把你当前的位置发给我哦。语音神马的我还不认识哟。谢谢 ^_^".should ==  node.xpath('Content').text
  end

  it "test check weixin token" do
    # signature  微信加密签名
    # timestamp  时间戳
    # nonce  随机数
    # echostr  随机字符串
    timestamp = Time.new.to_i.to_s
    nonce = "random"
    echostr = "helloworld"
    token = "colorweather"

    signature = Digest::SHA1.hexdigest([token, timestamp, nonce].sort.join)

    params = { :timestamp => timestamp, :nonce => nonce, :echostr => echostr, :signature => signature }
    get "/v1/weixin", params
    puts params.map{ |key, value| "#{key}=#{value}" }.join('&')

    response.status.should == 200
    echostr.should == response.body
  end
end
