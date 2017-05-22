import Data.Monoid
import System.IO

import XMonad
import XMonad.Actions.CycleWS (nextWS, prevWS)
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.DynamicLog hiding (xmobar)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe)


myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ className =? "Google-chrome" --> doShift "1"
   , className =? "Emacs"         --> doShift "2"
   , className =? "Terminator"    --> doShift "3"
   , className =? "Thunar"        --> doShift "4"
   , className =? "Xfce4-notifyd" --> doIgnore
   , isFullscreen                 --> doFullFloat
   , isDialog                     --> doCenterFloat
   ]

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ desktopConfig {
        terminal = "terminator"
      , modMask  = mod4Mask
      , logHook = dynamicLogWithPP xmobarPP {
              ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
      , manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
      , layoutHook = avoidStruts $ smartBorders $ layoutHook desktopConfig
      } `additionalKeysP` [

        ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
      , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")

      , ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 5%-")
      , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
      , ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 5%+")

      , ("s-<right>", nextWS)
      , ("s-<left>", prevWS)
      ]
