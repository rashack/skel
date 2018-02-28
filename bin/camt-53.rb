#!/usr/bin/env ruby

require 'nokogiri'

xml_str = File.read(ARGV[0])
doc = Nokogiri::XML(xml_str)
doc.remove_namespaces!

# doc.xpath(ARGV[1]).each do |node|
#   puts node.content
# end

def sum(xs)
  return xs.inject(0) {|s, n | s + n}
end

# Sum all amounts to cents
#    select all "//Amt " elements,
#                                  convert to text,
#                                        remove decimal dot,
#                                                     convert to integer,
def sum_and_n_transactions(doc)
  xs = doc.xpath("//Amt").map { |s| s.text.sub('.', '').to_i }
  puts xs.inject(0) {|s, n | s + n}
  puts xs.length
end

# print "Ustrd" values
def print_ustrd(doc)
  xs = doc.xpath("//Ustrd").map { |s| s.text }
  puts xs
end

# print "Ustrd" value from path specified below
def print_end_to_end_ref(doc)
  xs = doc.xpath("//NtryDtls/TxDtls/RmtInf/Ustrd").map { |s| s.text }
  puts xs
end

def print_reject_codes(doc)
  xs = doc.xpath("//RtrInf/Rsn/Cd").map { |s| s.text }
  puts xs
end

def ntrydtls_without_txdtls(doc)
  #xs0 = doc.xpath("//NtryDtls").select { |e| e.TxDtls != nil }
  #xs0 = doc.xpath("//NtryDtls").select { |e| e.xpath("/TxDtls") == nil }
  xs0 = doc.xpath("//NtryDtls").select { |e| e.xpath("/NtryRef") == nil }
  puts xs0.length
  #{ |s| s.text }
  #puts xs
end

def ntry_amts(doc)
  xs = doc.xpath("//Ntry/Amt").map { |s| s.text }
  puts xs
end

def parent_of_3m(doc)
  xs = doc.xpath("//Ntry/Amt[text()=3000000.00]/../..").map { |s| s.text }
  puts xs
end

# sum_and_n_transactions(doc)
# print_ustrd(doc)
# print_end_to_end_ref(doc)

#print_reject_codes(doc)

# ntrydtls_without_txdtls(doc)

# ntry_amts(doc)

parent_of_3m(doc)
