import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout
import XMonad.Config (defaultConfig)
import XMonad.Layout.NoBorders
import XMonad.Actions.NoBorders
import XMonad.Layout.Gaps
import XMonad.Hooks.DynamicLog hiding (xmobar)
import XMonad.Actions.CycleWS
import Data.Bits
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Util.Run (spawnPipe)
import System.IO (hPutStrLn)
import Graphics.X11
import XMonad.Layout.ThreeColumns


-- I want 10 workspaces (at least).
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

main :: IO ()
main = do
        xmproc <- spawnPipe "xmobar /home/kjell/.xmonad/xmobarrc"
        xmonad defaultConfig
         {
	   logHook = dynamicLogWithPP $ xmobarPP {
	                                           ppOutput = hPutStrLn xmproc
						 , ppTitle = xmobarColor "green" "" . shorten 256
                                                 }
	 , normalBorderColor  = "#334455"
         , focusedBorderColor = "#ff9900"
         , terminal           = "/home/kjell/bin/xmterm"
         , modMask = mod4Mask
	 , workspaces = myWorkspaces
         , layoutHook = gaps [(U,16)] (smartBorders (tiled ||| Full ||| ThreeCol 1 (0.8/100) (1/3)))
         , manageHook = composeAll [ className =? "fontforge" --> doFloat
                                   , className =? "Gimp"      --> doFloat
				   , className =? "sun-applet-Main" --> doFloat
				   , className =? "sun.applet.Main" --> doFloat
				   , className =? "vmware-server-console" --> doFloat
				   , className =? "Vmware-server-console" --> doFloat
				   , className =? "sun-plugin-navig-motif-Plugin" --> doFloat
				   ]
         , keys = \c -> mykeys c `M.union` keys defaultConfig c
         }
  where
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2 -- toRational (2/(1+sqrt(5)::Double)) -- golden

     -- Percent of screen to increment by when resizing panes
     delta   = 0.03

     mykeys (XConfig {XMonad.modMask = modm}) = M.fromList $
             [ ((controlMask .|. modm, xK_Right), nextWS)
             , ((controlMask .|. modm, xK_Left),  prevWS)
             , ((modm, xK_b     ), sendMessage $ ToggleGaps)
--	     , ((modm, xK_q     ), broadcastMessage ReleaseResources >> restart "xmonad" True) -- %! Restart xmonad
	     , ((modm, xK_g ),   withFocused toggleBorder)
	      ]
	      ++
    	     --
    	     -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    	     -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    	     --
             [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
	          | (key, sc) <- zip [xK_w, xK_e, xK_r, xK_s] [0, 1, 3, 2]
             , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]] ++
	     --
	     -- 10 workspaces config below
	     --
	     [ ((modm, k), windows $ W.greedyView i)
	         | (i, k) <- zip myWorkspaces workspaceKeys
	     ] ++
--	     [ ((modm .|. shiftMask, k), (windows $ W.shift i) >> (windows $ W.greedyView i))
	     [ ((modm .|. shiftMask, k), (windows $ W.shift i))
	         | (i, k) <- zip myWorkspaces workspaceKeys
	     ]
	     where workspaceKeys = [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0]
