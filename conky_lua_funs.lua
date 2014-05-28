
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
    return string.format("%s: ^fg(#%06x)%d^fg()", string, fg_colour, value)
end
