# encoding: utf-8
require 'city_code'

module Wechat
  class API < Grape::API
    
    version 'v1', :using => :path, :vendor => 'colorweather'
    format :txt
    content_type :xml, "text/xml"

    helpers WechatHelper

    resource :weixin do

      desc '彩虹天气微信接口校验'
      get do
        check_sign(params)
      end

      desc '彩虹天气微信接口'
      post do
        request_body = request.body.read
        #Rails.logger.info request_body
        status("200")
        response = get_city_weather_weixin(request_body)
        #Rails.logger.info response.to_xml
        response.to_xml
      end
    end
  end
end
