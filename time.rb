#!/usr/bin/env ruby
#
# time.rb
# 2018-02-05

def time_cmd
  Time.now.strftime("%c")
end

def mem_cmd
  `free -hg`.chomp
end

def mem_split
  mem_cmd.split(" ")
end



def time_out
  output = []
  output << "%{r}"
  output << "Mem: "
  output << mem_split[8]
  output << "/"
  output << mem_split[7]
  output << " | "
  output << time_cmd
  output << " "
  output
end

p time_out
