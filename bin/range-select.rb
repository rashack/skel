#!/usr/bin/env ruby

def usage
  "Usage: #{$0} PREFIX RANGE [RANGE...]\n\n" +
    "       PREFIX    only files starting with this string will be selected\n" +
    "       RANGE     files with a number within this closed range will be\n" +
    "                 selected. Each range consists of two sequences of digits\n" +
    "                 separated by a non digit character."
end

abort usage if ARGV.length < 2

def all_prefixed_files(prefix)
  return %x{ ls -1 #{prefix}* }.split("\n")
end

def files_in_range(files, prefix, range)
  min = range.sub(/(\d+).*/, '\1').to_i
  max = range.sub(/\d+\D+(\d+).*/, '\1').to_i
  prefix = '^' + prefix
  files.select do |file|
    num = file.sub(/#{prefix}/, '').sub(/(\d+).*/, '\1').to_i
    min <= num && num <= max
  end
end

prefix = ARGV[0]
ARGV.shift
prefixed_files = all_prefixed_files(prefix)
ARGV.each do |range|
  puts files_in_range(prefixed_files, prefix, range)
end
