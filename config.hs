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
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.Run (spawnPipe)
import qualified XMonad.StackSet as W

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ className =? "Alacritty"     --> doShift "1"
   , className =? "Terminator"    --> doShift "1"
   , className =? "Emacs"         --> doShift "2"
   , className =? "Google-chrome" --> doShift "3"
   , className =? "Thunar"        --> doShift "4"
   , className =? "Evince"        --> doShift "5"
   , className =? "Hexchat"       --> doShift "9"
   , className =? "Xfce4-notifyd" --> doIgnore
   , className =? "Pinentry"      --> doCenterFloat
   , isFullscreen                 --> doFullFloat
   , isDialog                     --> doCenterFloat
   ]

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ desktopConfig {
        terminal = "alacritty"
      , modMask  = mod1Mask
      , logHook = dynamicLogWithPP xmobarPP {
              ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
      , manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
      , layoutHook = avoidStruts $ smartBorders $ layoutHook desktopConfig
      , handleEventHook = fullscreenEventHook

      } `additionalKeysP` (additional ++ switch ++ kinesis) `removeKeysP` removed

  where

    removed = ["M-p"]

    -- Key codes: https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Util-EZConfig.html
    additional = [
        ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
      , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")

      , ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 5%-")
      , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
      , ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 5%+")

      , ("<XF86PowerOff>", spawn lock)
      , ("M-l", spawn lock)

      , ("<Insert>", toggleWS)
      , ("M-<Insert>", windows W.focusDown)

      , ("<Print>", spawn "$(yeganesh -x)")
      ]

    switch = [("<F" ++ x ++ ">", windows $ W.greedyView x) |
               x <- map show ([1..9] :: [Int])]

    -- Switch on kinesis with asdf and jkl; because numbers are far away
    kinesis = [("M-" ++ key, windows $ W.greedyView index) |
               (key, index) <- [("a", "1"), ("s", "2"), ("d", "3"), ("f", "4")]]

    lock = "i3lock -c 002b36 && systemctl suspend"
