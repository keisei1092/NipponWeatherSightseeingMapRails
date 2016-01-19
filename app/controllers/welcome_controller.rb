# -*- coding: utf-8 -*-

require 'open-uri'

class WelcomeController < ApplicationController
  def index
    weather_feeds = [
        "http://rss.weather.yahoo.co.jp/rss/days/1400.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/3410.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/4410.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/5410.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/5110.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/5610.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/6200.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/6610.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/7200.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/8210.xml",
        "http://rss.weather.yahoo.co.jp/rss/days/9110.xml"
    ]
    sight_feeds = [
      "http://guide.travel.co.jp/feed/archive/r1/",
      "http://guide.travel.co.jp/feed/archive/r2/",
      "http://guide.travel.co.jp/feed/archive/r3/",
      "http://guide.travel.co.jp/feed/archive/r4/",
      "http://guide.travel.co.jp/feed/archive/r5/",
      "http://guide.travel.co.jp/feed/archive/r6/",
      "http://guide.travel.co.jp/feed/archive/r7/",
      "http://guide.travel.co.jp/feed/archive/r8/",
      "http://guide.travel.co.jp/feed/archive/r9/",
      "http://guide.travel.co.jp/feed/archive/r10/",
      "http://guide.travel.co.jp/feed/archive/p47/"
    ]
    weather_string = case params[:weather]
      when "sunny"
        "晴"
      when "cloudy"
        "曇"
      when "rainy"
        "雨"
      when "snowy"
        "雪"
      else
        "晴"
      end
    @data = []
    weather_feeds.each_with_index do |feed_url, i|
      weather_feed = SimpleRSS.parse open(weather_feeds[i])
      weather_feed.items.each do |item|
        if item.title.force_encoding("UTF-8").include?("土")
          if item.description.force_encoding("UTF-8").include?(weather_string)
            elem = {}
            elem["area"] = convert_number_to_area_string(i)
            elem["info"] = {}
            elem["info"]["title"] = []
            elem["info"]["description"] = []
            elem["info"]["link"] = []
            sight_feed = SimpleRSS.parse open(sight_feeds[i])
            10.times do |j|
              elem["info"]["title"].push sight_feed.items[j].title.force_encoding("UTF-8").chomp("｜トラベルjp＜たびねす＞")
              elem["info"]["description"].push sight_feed.items[j].description.force_encoding("UTF-8")
              elem["info"]["link"].push sight_feed.items[j].link.force_encoding("UTF-8")
            end
            @data.push elem
          end
        end
      end
    end
  end

  private
    def convert_number_to_area_string(index)
      return case index
        when 0
          "北海道"
        when 1
          "東北"
        when 2
          "関東"
        when 3
          "信州・信越"
        when 4
          "東海"
        when 5
          "北陸"
        when 6
          "近畿"
        when 7
          "中国"
        when 8
          "四国"
        when 9
          "九州"
        when 10
          "沖縄"
      end
  end
end
