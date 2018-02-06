#!/usr/bin/env ruby
#
# lemonbar.rb
# 2018-02-04

#load "title.rb"
#load "bsp_tree.rb"
require "/home/derrick/.bin/wintitle"
require "/home/derrick/.bin/bsp_tree"
require "/home/derrick/.bin/time"

loop do
  lemonbar = desktops
  lemonbar += titles
  lemonbar += time_out
  puts lemonbar.join(" ")
  sleep 0.1
end

