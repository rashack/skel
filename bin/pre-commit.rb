#!/usr/bin/ruby -w

@exit_value = 0

@git_branch = %x[ git branch | grep -oP "^\\* \\K.*" ]

# Check that the branch name conforms to GBL-<team name>-NNNNN
def check_branch_name
  if /gbl-[0-9]+-monkey/i !~ @git_branch
    @exit_value = 1
    return "Bad branch name '#{@git_branch.chomp}'\n"
  end
end

@cached_files = %x[ git diff --cached --name-only ].split

def cached_diff_chunks(file)
  diff = %x[ git diff --cached #{file} ].split("\n").drop(4)
         .delete_if { |line| /^\-/ =~ line }

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
    cached_diff_chunks(file).each do |chunk|
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

errors = [ check_branch_name,
           check_chunks("Commas not followed by a space", ",[^ \\n]", @cached_files),
           check_chunks("Parenthesis with space on concave side", "\\( | \\)", @cached_files),
           check_chunks("Comment line beginning with single %%", "^\s*%[^%]", @cached_files)
         ].delete_if { |errs| errs == "" or errs == nil }
         .join "\n"
puts errors unless errors == ""

exit @exit_value
