#!/usr/bin/env ruby
#
# title.rb
# 2018-02-05

def sys_cad
  `xtitle`.chomp
end

def titles
  output = []
  output << "%{c}"
  output.push(sys_cad)
  output
end
