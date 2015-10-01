#!/usr/bin/env ruby

MAX = %x{cat /sys/class/backlight/intel_backlight/max_brightness}.to_f
CURR = %x{cat /sys/class/backlight/intel_backlight/brightness}.to_f
CURR_PERC = (CURR / MAX * 100).round.to_i

def get_to(prev, change)
  return change.to_i if /^\d+$/ =~ change
  /^(?<op>[+-])(?<val>\d+)/ =~ change
  return prev + val.to_i if op == "+"
  return prev - val.to_i if op == "-"
  return prev
end
to = get_to(CURR_PERC, ARGV[0])
to = 1 if to < 1

new = (MAX * to / 100).round
puts "Setting brightness to #{to}% (#{new}/#{MAX.to_i}), brightness was #{CURR_PERC}% (#{CURR}/#{MAX.to_i})"
%x{echo #{new} | sudo tee /sys/class/backlight/intel_backlight/brightness}
