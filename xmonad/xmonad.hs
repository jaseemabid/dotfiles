import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.PhysicalScreens
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (composeOne, isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import System.IO
import XMonad.Actions.SpawnOn

myManageHook = composeAll
   [ className =? "Chrome"        --> doShift "1"
   , className =? "Emacs"         --> doShift "2"
   , className =? "Terminator"    --> doShift "3"
   , className =? "Thunar"        --> doShift "4"
   , className =? "Skype"         --> doShift "5"
   , className =? "XChat"         --> doShift "6"
   , className =? "Xfce4-notifyd" --> doIgnore
   , isFullscreen                 --> doFullFloat
   , isDialog                     --> doCenterFloat
   ]

main = do
    xmproc <- spawnPipe "~/.cabal/bin/xmobar ~/.xmonad/xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig
        , terminal = "terminator"
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask, xK_Right), nextWS)
        , ((mod4Mask, xK_Left), prevWS)
        , ((mod4Mask .|. shiftMask, xK_s), spawn "dbus-send --print-reply --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend")
        , ((mod4Mask .|. shiftMask, xK_h), spawn "dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop")
        -- XF86AudioMute
        , ((0, 0x1008ff12), spawn "amixer -q set Master toggle")
        -- XF86AudioRaiseVolume
        , ((0, 0x1008ff13), spawn "amixer -q set Master 5%+")
        -- XF86AudioLowerVolume
        , ((0, 0x1008ff11), spawn "amixer -q set Master 5%-")
        -- XF86MonBrightnessUp
        , ((0, 0x1008ff02), spawn "xbacklight + 10")
        -- XF86MonBrightnessDown
        , ((0, 0x1008ff03), spawn "xbacklight - 10")
        ]
