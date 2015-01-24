gem 'awesome_print', :require => 'ap'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'date'
require 'rubygems'
require 'active_support/all'
require 'awesome_print'


#list of program xml urls to run through
%w[
http://www.moodyradio.org/brd_podcast.aspx?Program=ALoveLanguageMinute
http://www.moodyradio.org/brd_podcast.aspx?Program=AuthenticIntimacy
http://www.moodyradio.org/brd_podcast.aspx?Program=BringToMind
http://www.moodyradio.org/brd_podcast.aspx?Program=BuildingRelationships
http://www.moodyradio.org/brd_podcast.aspx?Program=ChrisFabryLive
http://www.moodyradio.org/brd_podcast.aspx?Program=IntheMarketwithJanetParshall
http://www.moodyradio.org/brd_podcast.aspx?Program=JanetParshallCommentary
http://www.moodyradio.org/brd_podcast.aspx?Program=JavaWithJuli
http://www.moodyradio.org/brd_podcast.aspx?Program=TheLandandtheBook
http://www.moodyradio.org/brd_podcast.aspx?Program=LivingALegacy
http://www.moodyradio.org/brd_podcast.aspx?Program=MiddayConnection
http://www.moodyradio.org/brd_podcast.aspx?Program=MoodyPresents
http://www.moodyradio.org/brd_podcast.aspx?Program=OpenLine
http://www.moodyradio.org/brd_podcast.aspx?Program=RadicalWithDavidPlatt
http://www.moodyradio.org/brd_podcast.aspx?Program=ThisIsTheDay
http://www.moodyradio.org/brd_podcast.aspx?Program=TodayintheWord
http://www.moodyradio.org/brd_podcast.aspx?Program=TreasuredTruth
http://www.moodyradio.org/brd_podcast.aspx?Program=UpforDebate
http://www.moodyradio.org/brd_podcast.aspx?Program=WhatDidTheySayNow
].each do |url|

# Grab xml url file
  xml = Nokogiri::XML(open(url))

# Search through doc for Program title
  channel =xml.search('channel').map do |channel|
    %w[
    title
  ].each_with_object({}) do |n, o|
      o[n] = channel.at(n)
    end
  end

# Search thru doc for episode title, link, and publish date
  item = xml.search('item').map do |item|
    %w[
    title link pubDate
  ].each_with_object({}) do |n, o|
      o[n] = item.at(n)
    end
  end

# Print out results of First Program
  ap channel
  ap item[0]

# Only print out item if second <item> contains 'Hour 2' string for two episode shows
  if item[1].to_s.include? 'Hour 2'
    ap item[1]
  end

# Search publish date and see when episodes were posted
  xml.xpath('//rss/channel/item/pubDate').each do |link|
    publish = Date.parse(link.content)
    if publish >= 7.days.ago
      puts publish
    end
  end

 end



