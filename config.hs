import Data.Monoid
import System.IO

import XMonad
import XMonad.Actions.CycleWS (toggleWS)
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.DynamicLog hiding (xmobar)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.Run (spawnPipe)
import qualified XMonad.StackSet as W

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ title =? "Any.do"            --> (doShift "9" <+> doCenterFloat)
   , className =? "Alacritty"     --> doShift "1"
   , className =? "Terminator"    --> doShift "1"
   , className =? "Emacs"         --> doShift "2"
   , className =? "Google-chrome" --> doShift "3"
   , className =? "Firefox"       --> doShift "4"
   , className =? "Thunar"        --> doShift "5"
   , className =? "Nautilus"      --> doShift "5"
   , className =? "Mattermost"    --> doShift "6"
   , className =? "Hexchat"       --> doShift "7"
   , className =? "Xfce4-notifyd" --> doIgnore
   , className =? "Pavucontrol"   --> doCenterFloat
   , className =? "Pinentry"      --> doCenterFloat
   , isFullscreen                 --> doFullFloat
   , isDialog                     --> doCenterFloat
   ]

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ docks desktopConfig {
        terminal = "alacritty"
      , modMask  = mod4Mask
      , logHook = dynamicLogWithPP xmobarPP {
              ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
      , manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
      , layoutHook = avoidStruts $ smartBorders $ layoutHook desktopConfig
      , handleEventHook = fullscreenEventHook
      , workspaces = ws
      , startupHook = setWMName "LG3D"
      } `additionalKeysP` (additional ++ switch ++ kinesis) `removeKeysP` removed

  where

    ws = map show ([1..9] :: [Int])

    removed = [] --["M-p"]

    -- Key codes: https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Util-EZConfig.html
    additional = [
        ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
      , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")

      , ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 5%-")
      , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
      , ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 5%+")

      -- On the Thinkpad, I'm unable to map to the power button, but Fn+Power is
      -- handled as XF86WakeUp. Disabled because unreliable
      -- , ("<XF86WakeUp>", spawn suspend)
      , ("M-l", spawn lock)

      , ("<Insert>", toggleWS)
      , ("M-<Insert>", windows W.focusDown)

      , ("<Print>", spawn "budgie-run-dialog")

      , ("M-n", spawn "nautilus")
      ]

    switch = [("<F" ++ x ++ ">", windows $ W.greedyView x) | x <- ws]

    -- Switch on kinesis with asdf because numbers are far away
    kkeys = ["a", "s", "d", "f"]

    kinesis = [("M-" ++ key, windows $ W.greedyView space) |
               (key, space) <- zip kkeys ws]

    lock = "i3lock -c 002b36"
    -- suspend = lock ++ " && systemctl suspend"
