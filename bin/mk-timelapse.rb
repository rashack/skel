#!/usr/bin/env ruby
# coding: utf-8

require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: foo.tb [options]"

  opts.on("-f PATTERN", "--file-pattern=PATTERN", String, "globbing pattern for input files") do |f|
    options[:input] = f
  end

  opts.on("-i FPS_IN", "--fps-in=FPS_IN", Integer, "frames per second from input") do |i|
    options[:fps_in] = i
  end
  opts.on("-o FPS_OUT", "--fps-out=FPS_OUT", Integer, "frames per second to output") do |i|
    options[:fps_out] = i
  end

  opts.on("-r RES", "--resolution=RES", String, "output resolution") do |r|
    options[:resolution] = r
  end

  opts.on("-n NAME", "--name=NAME", String, "name of output file") do |i|
    options[:name] = i
  end

end.parse!

def mk_cmd(opts)
  %W[
  ffmpeg -loglevel verbose
   -r #{opts[:fps_in]} -pattern_type glob -i '#{opts[:input]}'
   -r #{opts[:fps_out]} -vcodec libx264 -vf scale=#{opts[:resolution]}
   #{opts[:name]}
  ].join(' ')
end

p options
p ARGV
#ffmpeg -loglevel verbose -r 240 -pattern_type glob -i 'image-2017-06-01*.jpg' -r 240 -vcodec libx264 -vf scale=1280:720 timelapse-2017-06-01_00-24_20562-images_240fpsi-240fpso.mp4
cmd = mk_cmd(options).to_s
p cmd

system(cmd)
#exec(cmd)
#%(cmd)
#%(#{cmd})
