import Data.Monoid
import Data.Ratio
import System.IO
import XMonad
import XMonad.Actions.CycleWS (toggleWS)
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat)
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.Run (spawnPipe)
import qualified XMonad.StackSet as W

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ className =? "Alacritty"     --> doShift "1"
   , className =? "kitty"         --> doShift "1"
   , className =? "Terminator"    --> doShift "1"
   , className =? "Emacs"         --> doShift "2"
   , className =? "Google-chrome" --> doShift "3"
   , className =? "firefox"       --> doShift "4"
   , className =? "Firefox"       --> doShift "4"
   , className =? "Firefox Beta"  --> doShift "4"
   , className =? "Spotify"       --> doShift "9"
   , className =? "Arandr"        --> doCenterSizedFloat
   , className =? "Blueberry.py"  --> doCenterSizedFloat
   , className =? "Pavucontrol"   --> doCenterSizedFloat
   , className =? "Pinentry"      --> doCenterFloat
   , className =? "Xfce4-notifyd" --> doIgnore
   , isFullscreen                 --> doFullFloat
   , isDialog                     --> doCenterFloat
   ]
   where
     -- Force a window to be in the middle of the screen with half the screen
     -- size. This is necessary for all apps that start with wrong window size
     -- hints.
     middle = (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
     doCenterSizedFloat = doRectFloat middle

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ docks desktopConfig {
        terminal = "kitty"
      , modMask  = mod4Mask
      , logHook = dynamicLogWithPP xmobarPP {
              ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "#d8dee9" "" . shorten 50
            }
      , manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
      , layoutHook = avoidStruts $ smartBorders $ layoutHook desktopConfig
      , handleEventHook = fullscreenEventHook
      , workspaces = ws
      , startupHook = setWMName "LG3D"
      } `additionalKeysP` (additional ++ kinesis) `removeKeysP` removed

  where

    ws = map show ([1..9] :: [Int])

    removed = [] --["M-p"]

    -- Key codes: https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Util-EZConfig.html
    additional = [
        ("<XF86MonBrightnessDown>", spawn "brightness -")
      , ("<XF86MonBrightnessUp>", spawn "brightness +")

      , ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 5%-")
      , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
      , ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 5%+")

      , ("<Insert>", toggleWS)
      , ("<Print>", spawn "gnome-screenshot -i")
      , ("M-<Insert>", windows W.focusDown)
      , ("M-S-l", spawn lock)
      , ("M-S-n", spawn "nautilus")
      , ("M-S-p", spawn "budgie-run-dialog")
      -- "Type" clipboard into password fields to deal with crappy banking websites
      , ("M-v", spawn "xdotool type --clearmodifiers -- $(xsel --clipboard --output)")
      ]

    -- Switch on Kinesis with asdf because numbers are far away
    kinesis = [("M-" ++ key, windows $ W.greedyView space) |
                (key, space) <- zip ["a", "s", "d", "f"] ws]

    lock = "i3lock -c 2e3440"
