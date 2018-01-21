#!/usr/bin/env ruby
#
# mondeskpanel.rb
# 2018-01-20

require 'barr'
require 'json'

class Mondesk < Barr::Block
  
  def initialize opts={}
    super
  end

  def update!
    monitor_hsh = Hash.new
    desktop_hsh = Hash.new
    @result_parse = JSON.parse(sys_cmd)
    
    @result_parse["monitors"].each do |x|
      monitor_hsh[x["id"]] = x["name"]
    end

    if focused_mon(monitor_hsh) == "HDMI2"
      @num = 0
    else
      @num = 1
    end

    @result_parse["monitors"][@num]["desktops"].each do |x|
      desktop_hsh[x["id"]] = x["name"]
    end

    @output = "Mon: #{focused_mon(monitor_hsh)} Desk: #{focused_desk(desktop_hsh)}" 
  end

  def sys_cmd
    `bspc wm -d`.chomp
  end

  def focused_mon(hash)
    focused_mon =  @result_parse["focusedMonitorId"]
    hash[focused_mon]
  end

  def focused_desk(hash)
    focused_desk = @result_parse["monitors"][@num]["focusedDesktopId"]
    hash[focused_desk]
  end
  
end 

@man = Barr::Manager.new

mondesk = Mondesk.new align: :l, interval: 1, bgcolor: '#1793D1', fgcolor: '#D3D3D3'

time = Barr::Blocks::Clock.new format: '%H:%M', icon: "\uf017", bgcolor: '#1793D1', fgcolor: '#D3D3D3', align: :r
date = Barr::Blocks::Clock.new format: '%d of %b %Y', bgcolor: '#1793D1', fgcolor: '#D3D3D3', align: :r, icon: "\uf073"

mem = Barr::Blocks::Memory.new icon: 'RAM:', align: :r, bgcolor: '#1793D1', fgcolor: '#D3D3D3' 

xtitle = Barr::Blocks::Xtitle.new align: :c, fgcolor: '#D3D3D3', interval: 1

@man.add mondesk
@man.add mem
@man.add date
@man.add time
@man.add xtitle

@man.run!




