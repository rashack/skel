#!/usr/bin/env ruby

MAX = %x{cat /sys/class/backlight/intel_backlight/max_brightness}.to_f
CURR = %x{cat /sys/class/backlight/intel_backlight/brightness}.to_f
CURR_PERC = (CURR / MAX * 100).round.to_i

TO = ARGV[0].to_i

NEW = (MAX * TO / 100).round
puts "Setting brightness to #{TO}% (#{NEW}/#{MAX.to_i}), brightness was #{CURR_PERC}% (#{CURR}/#{MAX.to_i})"
%x{echo #{NEW} | sudo tee /sys/class/backlight/intel_backlight/brightness}
