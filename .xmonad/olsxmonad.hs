import XMonad
--import XMonad.Hooks.DynamicLog
--import XMonad.Hooks.ManageDocks
--import XMonad.Util.Run(spawnPipe)
--import XMonad.Util.EZConfig(additionalKeys)
--import System.IO

main = do
  xmonad $ defaultConfig
    { --manageHook = manageDocks <+> manageHook defaultConfig
    --, layoutHook = avoidStruts  $  layoutHook defaultConfig
--    , logHook = dynamicLogWithPP $ xmobarPP
--          { ppOutput = hPutStrLn xmproc
--          , ppTitle = xmobarColor "green" "" . shorten 50
--          }
      modMask = mod4Mask
    , terminal = "xterm -fg gray -bg black -cr red -ls -sl 2048 -vb +sb -fn -misc-fixed-medium-r-semicondensed-*-13-120-75-75-c-60-iso8859-*"
    }
