
function conky_lc(what, string)
   value=tonumber(conky_parse("${" .. what .. "}"))
   if value >= 70 then
      fg_colour=0xff0000
   elseif value >= 20 then
      fg_colour=0xff7f00
   elseif value >= 15 then
      fg_colour=0xffff00
   else
      fg_colour=0x00ff00
   end
   return string.format("%s: ^fg(#%06x)%2d^fg()", string, fg_colour, value)
end

function conky_lc_n(what, string)
   value=tonumber(conky_parse("${" .. what .. "}"))
   if value >= 60 then
      fg_colour=0x0000ff
   elseif value >= 50 then
      fg_colour=0x7fff00
   elseif value >= 15 then
      fg_colour=0xffff00
   else
      fg_colour=0xff0000
   end
   return string.format("%s: ^fg(#%06x)%d^fg()", string, fg_colour, value)
end
