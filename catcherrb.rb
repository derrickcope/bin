#!/usr/bin/env ruby
#
# podcaster.rb
# 2018-03-14
#

require 'feedjira'
require 'down'
require 'yaml'
require 'fileutils'

class Podcasts
  include Down
  include Feedjira
  include YAML
  include FileUtils

  attr_reader :feedyaml, :logyaml, :log_ary, :feed, :link, :title, :feedtitle, :feed_hsh, :feed_ary
  def initialize(feedyaml, logyaml)
    @feedyaml = feedyaml
    @logyaml = logyaml
  end
  def checkconfig
    samplelog_ary = ["first.mp3", "another.mp3", "random.mp3"]
    samplefeed_hsh = {"global"=>"some global setting", "preferrence"=>"some preference", "feeds" => {"feed01"=>{"title"=>"title of feed", "rss"=>"http://www.somefeed.com/rss", "many"=>5, "remark"=>"so so"}, "feed02"=>{"feed02"=>"title of feed2", "rss"=>"https://www.anotherfeed.com/feed.xml", "many"=> 3, "remark"=>"bad"}}}
    unless File.exist?(logyaml)
      puts "creating log file"
      File.open(logyaml, "w+").write(samplelog_ary.to_yaml)
      abort("please run app again to create feed.yml")
    end
    unless File.exist?(feedyaml)
      puts "creating feed file"
      File.open(feedyaml, "w+").write(samplefeed_hsh.to_yaml)
      abort("please configure news feeds in feed.yml and then run app")
    end
  end
  def parse(uri)
    puts "parsing #{uri}"  
    feedparse = Feedjira::Feed.fetch_and_parse(uri)
    @feedtitle = feedparse.title
    @feed = feedparse.entries.first
    @title = feedparse.entries.first.title 
    case 
    when (feedparse.entries.first).respond_to?(:guid)
      @link = feedparse.entries.first.guid
    when (feedparse.entries.first).respond_to?(:enclosure_url)
      @link = feedparse.entries.first.enclosure_url
    when (feedparse.entries.first).respond_to?(:image)
      @link = feedparse.entries.first.image
    else
      puts "no link"
    end
  end
  def getlog
    puts "opening log"
    @log_ary = YAML.load_file(logyaml)
  end
  def writelog
    puts "writing log"
    #@log_ary
    File.open(logyaml, "r+").write(log_ary.to_yaml)
  end
  def getfeeds
    @feed_ary = []
    puts "getting feeds"
    @feed_hsh = YAML.load_file(feedyaml)
    feed_hsh["feeds"].each do |key,value|
      feed_ary.push(value["rss"])
    end
    feed_ary
  end
  def getdown
    feed_ary.each do |feed|
      parse(feed)
      puts "trying #{feedtitle}"
      puts "save folder #{feed_hsh["save folder"]}"
      unless Dir.exist?("#{feed_hsh["save folder"]}/#{feedtitle.downcase.delete(" ")}")
        puts "making #{feedtitle.downcase.delete(" ")} folder"
        FileUtils.mkdir("#{feed_hsh["save folder"]}/#{feedtitle.downcase.delete(" ")}")
      else puts "folder exists"
      end
      unless log_ary.include?("#{title.downcase.delete(" ")}.mp3")
        puts "downloading #{title.downcase.delete(" ")}.mp3"
        tempfile = Down.open(link, rewindable: false)
        IO.copy_stream(tempfile, "#{feed_hsh["save folder"]}/#{feedtitle.downcase.delete(" ")}/#{title.downcase.delete(" ")}.mp3")
        tempfile.close
        log_ary.push("#{title.downcase.delete(" ")}.mp3")
        #@log_ary
      else puts "file exists in log"
      end
    rescue Faraday::ConnectionFailed, Down::TimeoutError, Down::TooManyRedirects, Down::ConnectionError
      next
    end
  end
end


# the absolute path names of the feed and log config files as arguments to the instance.
podcasts = Podcasts.new("/home/derrick/code/ruby/Catcherrb/feeds.yml", "/home/derrick/code/ruby/Catcherrb/log.yml")

# check to see if the config files exist, if they dont they will be created and the app will abort
# so that you can configure them
podcasts.checkconfig    

# read the feeds and other preferences into the instance
podcasts.getfeeds

# read the logfile into the instance
podcasts.getlog

# download the latest podcast in each feed and save it in a separate folder for each feed
podcasts.getdown

# writes the podcasts that were successfully downloaded to the log.yml file
podcasts.writelog
