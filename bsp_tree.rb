#!/usr/bin/env ruby
#
# bsp_tree.rb
# 2018-02-04
STDOUT.sync = true

require 'json'

$invert_colors = '%{R}'
$invert_focus_colors = true
$focus_markers = ["[", "]"]

def sys_cmd
  `bspc wm -d`.chomp
end

def bsp_tree
  JSON.parse(sys_cmd)
end

def first_monitor
  bsp_tree["monitors"].first["id"]
end

def focused_desktop desktop
  op = ""
  op += $invert_colors if $invert_focus_colors
  op += $focus_markers[0] + " "
  op += desktop["name"]
  op += " " + $focus_markers[1]
  op += $invert_colors if $invert_focus_colors
end

def unfocused_desktop desktop
  op = ""
  op += "%{A:bspc desktop -f #{desktop["id"]}:} "
  op += "#{desktop["name"]}"
  op += " %{A}"

  return op
end


def desktops
  op = []
  bsp_tree["monitors"].each do |monitor|
    focused = monitor["focusedDesktopId"]
    op << " " + monitor["name"] + ":"
    monitor["desktops"].each do |desktop|
      if desktop["id"] == focused and monitor["id"] == bsp_tree["focusedMonitorId"]
        op << focused_desktop(desktop)
      else
        op << unfocused_desktop(desktop)
      end
    end
  end
  op
end


