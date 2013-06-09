# encoding: utf-8
require 'city_code'

module Weather
  class API < Grape::API
    
    version 'v1', :using => :path, :vendor => 'colorweather'
    format  :json

    helpers WeatherHelper

    resource :weather do
      
      desc "通过cityno获取城市天气信息"
      params do
        requires :cityno, :type => String, :desc => "请输入城市编号."
      end
      get 'city/:cityno' do
        get_weather_info_by_cityno(params[:cityno])
      end

      desc '根据经纬度获取天气信息'
      get 'lat/:lat/lng/:lng', :requirements => {:lat => /\-*\d+.\d+/, :lng => /\-*\d+.\d+/} do
        city_no = get_city_no_by_lat_lon(params[:lat], params[:lng])

        unless city_no
          error!('Unexpect lat and lng', 400)
        end

        get_weather_info_by_cityno(city_no)
      end
      
      desc '获取版本信息'
      get :version do
        Setting.get_version_setting
      end

    end
  end
end
