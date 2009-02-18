import XMonad
import XMonad.Hooks.DynamicLog

main = dzen $  \x -> xmonad $ defaultConfig
    { terminal           = "xterm -fg gray -bg black -cr red -ls -sl 1024 -vb +sb -fn -misc-fixed-medium-r-semicondensed-*-13-120-75-75-c-60-iso8859-*"
    , modMask = mod4Mask
--    , borderWidth        = 2
--    , normalBorderColor  = "#cccccc"
--    , focusedBorderColor = "#cd8b00"
    }
