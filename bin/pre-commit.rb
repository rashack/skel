#!/usr/bin/env ruby

@exit_value = 0

@git_branch = %x[ git branch | grep -oP "^\\* \\K.*" ]
# or (if not GNU grep?)
# @git_branch = %x[ git branch | sed -n "s/^\* \(.*\)/\1/p"

# Check that the branch name conforms to GBL-<team name>-NNNNN
def check_branch_name
  if /gbl-[0-9]+-monkey/i !~ @git_branch
    @exit_value = 1
    return "Bad branch name '#{@git_branch.chomp}'\n"
  end
end

def diff_chunks(file)
  diff = @diff_fun.call file

  chunk_head = "^@@.*@@"
  line_number = 0
  chunk = []
  res = []
  diff.each do |line|
    if /#{chunk_head}/ !~ line
      chunk.push([line_number, line])
      line_number += 1
    else
      /^@@ -\d+,\d+ \+(\d+),\d+ @@/ =~ line
      line_number = $1.to_i
      res.push(chunk) if chunk != []
      chunk = []
    end
  end
  res.push(chunk)
end

def check_chunks(err_msg, regex, files)
  errs = ""
  files.each do |file|
    diff_chunks(file).each do |chunk|
      chunk.each do |line|
        l, str = line
        if /^\+/ =~ str
          diff = str.gsub(/^\+/, "")
          if /#{regex}/ =~ diff
            errs = "#{errs}#{file}:#{l}: #{diff}\n"
          end
        end
      end
    end
  end
  if errs != ""
    @exit_value = 1
    return "#{err_msg}:\n#{errs}"
  end
end

def diff_cached(file)
  postprocess_diff %x[ git diff --cached #{file} ]
end

def diff_commit(file)
  postprocess_diff %x[ git show #{ARGV[0]} -- #{file} ]
end

def diff_modified(file)
  postprocess_diff %x[ git diff #{file} ]
end

def postprocess_diff(diff)
  diff.force_encoding("iso-8859-1").split("\n").drop(4).delete_if { |line| /^\-/ =~ line }
end

if ARGV.length == 0
  @files = %x[ git diff --cached --name-only ].split
  @diff_fun = lambda { |file| diff_cached file }
elsif ARGV[0] == "--"
  @files = %x[ git ls-files -m ].split
  @diff_fun = lambda { |file| diff_modified file }
else
  @files = %x[ git diff-tree --no-commit-id --name-only -r #{ARGV[0]} ].split
  @diff_fun = lambda { |file| diff_commit file }
end

errors = [ check_branch_name,
           check_chunks("Commas not followed by a space", ",[^ \\n]", @files),
           check_chunks("Parenthesis with space on concave side", "\\( | \\)", @files),
           check_chunks("Comment line beginning with single %%", "^\s*%[^%]", @files),
           check_chunks("Line too long", ".{81,}", @files)
         ].delete_if { |errs| errs == "" or errs == nil }
         .join "\n"
puts errors unless errors == ""

exit @exit_value
