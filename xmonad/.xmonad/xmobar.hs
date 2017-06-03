Config {
    font = "xft:Fira Code Mono:size=16,FontAwesome:size=15:antialias=true"
  , bgColor = "#002b36"
  , fgColor = "#657b83"
  , position = Bottom x
  , sepChar = "%"
  , allDesktops = True
  , alignSep = "}{"
  , template = " %StdinReader% }{ %dynnetwork%   %multicpu%   %memory%   %bright%   %volume%   %coretemp%   %battery%   %date% "
  , commands = [
    Run Brightness   ["--template"  , " <percent>%"
                     , "--"
                     , "--device"   ,  "intel_backlight"] 100

    -- battery monitor
  , Run Battery      [ "--template" , " <acstatus>"
                     , "--Low"      , "10"        -- units: %
                     , "--High"     , "80"        -- units: %
                     , "--low"      , "darkred"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkgreen"
                     , "--"
                     -- battery specific options
                     -- discharging status
                     , "-o"         ,"<left>%"
                     -- AC "on" status
                     , "-O"	    , "<fc=#dAA520></fc>"
                     -- charged status
                     , "-i"	    , "<fc=#006000></fc>"
                     ] 50

    -- network activity monitor (dynamic interface resolution)
    , Run DynNetwork [ "--template" , " [<rx> <tx>] kB/s"
                     , "--Low"      , "1000"       -- units: B/s
                     , "--High"     , "5000"       -- units: B/s
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     ] 10

    -- cpu activity monitor
    , Run MultiCpu   [ "--template" , " [<autototal>]%"
                     , "--Low"      , "50"         -- units: %
                     , "--High"     , "85"         -- units: %
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     , "-p"         , "2"
                     ] 10

      -- cpu core temperature monitor
    , Run CoreTemp   [ "--template" , " <core0>°C"
                     , "--Low"      , "70"        -- units: °C
                     , "--High"     , "80"        -- units: °C
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     ] 100

    -- memory usage monitor
    , Run Memory     [ "--template" ," <usedratio>%"
                     , "--Low"      , "20"        -- units: %
                     , "--High"     , "90"        -- units: %
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     ] 10

    , Run Com "volume" [] "" 10
    , Run Date " %a %b %d   %l:%M:%S %p " "date" 10
    , Run StdinReader]
}
