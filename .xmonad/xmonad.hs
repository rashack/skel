import Data.Bits
import Data.Default (def)
import Graphics.X11
import System.IO (hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicLog hiding (xmobar)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName -- for swing applications
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutScreens
import XMonad.Layout.MultiColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.TwoPane
import XMonad.Util.Loggers
import XMonad.Util.Run (spawnPipe)
import qualified Data.Map as M
import qualified XMonad.StackSet as W

-- I want 10 workspaces (at least).
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+"]
myTitleFgColor = "white"

myLayout = gaps [(U,18)] (smartBorders (tiled ||| full ||| threeCol ||| resizableTall))
           where
             toggleReflect l = toggleLayouts (reflectHoriz $ l) l
             tiled           = toggleReflect (Tall 1 0.03 0.5)
             threeCol        = toggleReflect (ThreeCol 1 (0.8/100) (1/3))
             full            = toggleLayouts Full (tabbed shrinkText myTabConfig)
             resizableTall   = ResizableTall 1 (3/100) (1/2) []

myTabConfig = def {   activeBorderColor = "#FF9900",   activeColor = "#444444",   activeTextColor = "#00CC00"
                  , inactiveBorderColor = "#444444", inactiveColor = "#222222", inactiveTextColor = "#888888"}

main :: IO ()
main = do
        h <- spawnPipe "~/bin/dzen2-status"
        spawn "~/bin/dzen2-time"
        spawn "~/bin/dzen2-idle"
        spawn "~/bin/dzen2-load"
        xmonad (ewmh $ withUrgencyHook NoUrgencyHook def)
         {
           --dzen2
           logHook = dynamicLogWithPP $ def { ppOutput = hPutStrLn h
                                            , ppCurrent = wrapFg "yellow" . wrap "[" "]"
                                            , ppVisible = wrap "(" ")"
                                            , ppSep = wrapFg "grey" " | "
                                            , ppTitle = (\x -> wrapFg myTitleFgColor x)
                                            , ppUrgent = dzenColor "dark orange" "" .  dzenStrip
                                            }
         , normalBorderColor  = "#334455"
         , focusedBorderColor = "#ff9900"
         , terminal           = "~/bin/xmterm"
         , modMask = mod4Mask
         , workspaces = myWorkspaces
         , layoutHook = myLayout
         , manageHook = composeAll [ className =? "fontforge" --> doFloat
                                   , className =? "stalonetray" --> doIgnore
                                   , className =? "Gimp"      --> doFloat
                                   , className =? "sun-applet-Main" --> doFloat
                                   , className =? "sun.applet.Main" --> doFloat
                                   , className =? "vmware-server-console" --> doFloat
                                   , className =? "Vmware-server-console" --> doFloat
                                   , className =? "sun-plugin-navig-motif-Plugin" --> doFloat
                                   ]
         , keys = \c -> mykeys c `M.union` keys def c
         , startupHook = setWMName "LG3D" -- for swing applications
         , focusFollowsMouse = True
         }
  where
     wrapFg color content = wrap ("^fg(" ++ color ++ ")") "^fg()" content

     mykeys (XConfig {XMonad.modMask = modm}) = M.fromList $
             [ ((controlMask .|. modm, xK_Right), nextWS)
             , ((controlMask .|. modm, xK_Left),  prevWS)
             , ((modm, xK_b), sendMessage $ ToggleGaps)
             , ((modm, xK_q), spawn myRestart         ) -- Restart xmonad
             , ((modm, xK_g), withFocused toggleBorder)
             , ((modm .|. controlMask, xK_space), sendMessage ToggleLayout)
             , ((modm .|. controlMask .|. shiftMask, xK_Return), spawn "~/bin/xterm-latin1")
             , ((modm .|. shiftMask,                 xK_space), layoutSplitScreen 2 (TwoPane 0.25 0.75))
             , ((modm .|. controlMask .|. shiftMask, xK_space), rescreen)
             , ((modm, xK_a), sendMessage MirrorShrink)
             , ((modm, xK_z), sendMessage MirrorExpand)
             , ((modm, xK_i), spawn "~/bin/passmenu")
             , ((modm, xK_o), spawn "PASSWORD_STORE_DIR=~/.pass-store-w ~/bin/passmenu")
             , ((modm, xK_s), spawn "~/bin/screenshot.sh")
             ]
             ++
             [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
                  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0, 1, 2]
             , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]] ++
             [ ((modm, k), windows $ W.greedyView i)
                 | (i, k) <- zip myWorkspaces workspaceKeys
             ] ++
             [ ((modm .|. shiftMask, k), (windows $ W.shift i))
                 | (i, k) <- zip myWorkspaces workspaceKeys
             ]
             where workspaceKeys = [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0, xK_plus]
     myRestart  = "for pid in `pgrep conky`; do kill -9 $pid; done && " ++
                  "for pid in `pgrep dzen2`; do kill -9 $pid; done && " ++
                  "xmonad --recompile && xmonad --restart"
