#!/usr/bin/env ruby
# coding: utf-8

require 'text-table'

def model(dev)
  %x{ sudo hdparm -I #{dev} | sed -n 's/.*Model Number: \\+\\(.*\\)/\\1/p' }.strip
end

def serial(dev)
  %x{ sudo hdparm -I #{dev} | sed -n 's/.*Serial Number: \\+\\(.*\\)/\\1/p' }.strip
end

def label(dev)
  %x{ sudo blkid -s LABEL #{dev} | sed -n 's/.*LABEL="\\([^"]\\+\\)"/\\1/p' }.strip
end

def uuid(dev)
  %x{ sudo blkid -s UUID #{dev} | sed -n 's/.*UUID="\\([^"]\\+\\)"/\\1/p' }.strip
end

def mount_point(dev)
  %x{ mount | grep '#{dev} on ' | sed -n 's|#{dev} on \\([^ ]\\+\\) .*|\\1|p' }.strip
end

def stats_headings
  ["Size", "Used", "Avail", "Use%", "Mounted on"]
end

def stats(dev)
  s = %x{ df -h #{dev} | tail -1 }.strip.split(" ").drop(1)
  return s.take(4) << "" if s[4] == "/dev"
  s
end

def headings
  ["Dev"] + stats_headings + ["Label", "Model", "Serial", "UUID"]
end

def wide(dev)
  [dev] + stats(dev) + [label(dev), model(dev), serial(dev), uuid(dev)]
end

def devs
  %x{ ls /dev/sd* }.split("\n")
end

def size(dev)
  %x{ sudo fdisk -l #{dev} | sed -n 's|Disk #{dev}: \\([^,]\\+\\),.*|\\1|p' }.strip.gsub(" ", "").gsub("iB", "")
end

def partitions(dev)
  %x{ sudo fdisk -l #{dev} | sed -n 's|^\\(#{dev}[0-9]\\+\\).*|\\1|p' }.split("\n")
end

def drives
  res = []
  %x{ ls /dev/sd? }.split("\n").each do |dev|
    #      dev     size,       used, avail, use%, mount_point,      label,      model,      serial,      uuid
    res << [dev] + [size(dev), "",   "",    "",   mount_point(dev), label(dev), model(dev), serial(dev), uuid(dev)]
    partitions(dev).each do |part|
      res << wide(part)
    end
  end
  res
end

t2 = Text::Table.new
t2.head = headings
t2.rows = []
t2.rows = drives
puts t2.to_s
