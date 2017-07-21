import Data.Monoid
import System.IO

import XMonad
import XMonad.Actions.CycleWS (toggleWS)
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.DynamicLog hiding (xmobar)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe)

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ className =? "Alacritty"     --> doShift "1"
   , className =? "Terminator"    --> doShift "1"
   , className =? "Emacs"         --> doShift "2"
   , className =? "Google-chrome" --> doShift "3"
   , className =? "Thunar"        --> doShift "4"
   , className =? "Xfce4-notifyd" --> doIgnore
   , isFullscreen                 --> doFullFloat
   , isDialog                     --> doCenterFloat
   ]

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ desktopConfig {
        terminal = "alacritty"
      , modMask  = mod4Mask
      , logHook = dynamicLogWithPP xmobarPP {
              ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
      , manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
      , layoutHook = avoidStruts $ smartBorders $ layoutHook desktopConfig
      , handleEventHook = fullscreenEventHook

      } `additionalKeysP` [

        -- Key codes: https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Util-EZConfig.html

        ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
      , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")

      , ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 5%-")
      , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
      , ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 5%+")

      , ("<XF86PowerOff>", spawn "i3lock -c 002b36 && systemctl suspend")

      , ("<Insert>", toggleWS)

      , ("M-l", spawn "i3lock -c 002b36")
      , ("M-f", spawn "thunar")
      ]
