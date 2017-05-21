import System.IO

import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (composeOne, isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run (spawnPipe)
import Data.Monoid

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

myConfig xmproc = xmonad desktopConfig {
    terminal = "terminator"
  , modMask  = mod4Mask
  , logHook = dynamicLogWithPP xmobarPP {
          ppOutput = hPutStrLn xmproc
        , ppTitle = xmobarColor "green" "" . shorten 50
        }
  , manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
  , layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig
  }

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    myConfig xmproc
