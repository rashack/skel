#!/usr/bin/env ruby
# coding: utf-8

require 'text-table'

def model_sata(dev)
  %x{ sudo hdparm -I #{dev} | sed -n 's/.*Model Number: \\+\\(.*\\)/\\1/p' }.strip
end

def model_nvme(dev)
  %x{ sudo nvme id-ctrl #{dev} | grep '^mn[^a-z]' | awk -F : '{print $2}' }.strip
end

def serial_sata(dev)
  %x{ sudo hdparm -I #{dev} | sed -n 's/.*Serial Number: \\+\\(.*\\)/\\1/p' }.strip
end

def serial_nvme(dev)
  %x{ sudo nvme id-ctrl #{dev} | grep '^sn[^a-z]' | awk -F : '{print $2}' }.strip
end

def label_sata(dev)
  %x{ sudo blkid -s LABEL #{dev} | sed -n 's/.*LABEL="\\([^"]\\+\\)"/\\1/p' }.strip
end

def label_nvme(dev)
  %x{ lsblk -no LABEL #{dev} }.strip
end

def uuid_sata(dev)
  %x{ sudo blkid -s UUID #{dev} | sed -n 's/.*UUID="\\([^"]\\+\\)"/\\1/p' }.strip
end

def uuid_nvme(dev)
  %x{ lsblk -plnf #{dev} | grep '^#{dev}[^a-z0-9]' | awk '{print $4}' }.strip
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
  ["Dev"] + stats_headings + ["Label", "Model", "Serial", "UUID", "APM_level", "Power_state"]
end

def wide_sata(dev)
  [dev] + stats(dev) + [label_sata(dev), model_sata(dev), serial_sata(dev), uuid_sata(dev), "", ""]
end

def wide_nvme(dev)
  [dev] + stats(dev) + [label_nvme(dev), model_nvme(dev), serial_nvme(dev), uuid_nvme(dev), "", ""]
end

def devs
  %x{ ls /dev/sd* }.split("\n")
end

def size(dev)
  %x{ sudo fdisk -l #{dev} | sed -n 's|Disk #{dev}: \\([^,]\\+\\),.*|\\1|p' }.strip.gsub(" ", "").gsub("iB", "")
end

def partitions_sata(dev)
  %x{ sudo fdisk -l #{dev} | sed -n 's|^\\(#{dev}[0-9]\\+\\).*|\\1|p' }.split("\n")
end

def partitions_nvme(dev)
  %x{ sudo fdisk -l #{dev} | sed -n 's|^\\(#{dev}p[0-9]\\+\\).*|\\1|p' }.split("\n")
end

def apm_level(dev)
  %x{ sudo hdparm -B #{dev} | grep APM_level | awk -F= '{print $2}' }.strip
end

def power_state(dev)
  %x{ sudo hdparm -C #{dev} | grep "drive state is" | awk -F: '{print $2}' }.strip
end

def drives
  res = []

  %x{ ls /dev/sd? }.split("\n").each do |dev|
    #      dev            size,       used, avail, use%, mount_point,      label,           model,           serial,           uuid,           apm_level,      power_state
    res << ["#{dev} *"] + [size(dev), "",   "",    "",   mount_point(dev), label_sata(dev), model_sata(dev), serial_sata(dev), uuid_sata(dev), apm_level(dev), power_state(dev)]
    #res << ["\e[44m#{dev}\e[0m"] + [size(dev), "",   "",    "",   mount_point(dev), label_sata(dev), model_sata(dev), serial_sata(dev), uuid_sata(dev)]
    partitions_sata(dev).each do |part|
      res << wide_sata(part)
    end
  end

    %x{ sudo nvme list | tail +3 | awk '{print $1}' }.split("\n").each do |dev|
    #      dev            size,       used, avail, use%, mount_point,      label,           model,           serial,           uuid,           apm_level,      power_state
    res << ["#{dev} *"] + [size(dev), "",   "",    "",   mount_point(dev), label_nvme(dev), model_nvme(dev), serial_nvme(dev), uuid_nvme(dev), "",             ""]
    partitions_nvme(dev).each do |part|
      res << wide_nvme(part)
    end
  end

  res
end

t2 = Text::Table.new
t2.head = headings
t2.rows = []
t2.rows = drives
puts t2.to_s.gsub(/(\/dev\/.+ \*)/, "\e[44m\\1\e[0m")
