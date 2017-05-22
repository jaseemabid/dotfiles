Config {
    font = "xft:Fira Code Mono:size=16:antialias=true"
  , bgColor = "#002b36"
  , fgColor = "#657b83"
  , position = Bottom x
  , sepChar = "%"
  , alignSep = "}{"
  , template = " %StdinReader% }{ %memory% | %multicpu% | %coretemp% | %dynnetwork% | %battery% | <fc=#ee9a00>%date%</fc>  "
  , commands = [
    -- battery monitor
    Run Battery      [ "--template" , "Batt: <acstatus>"
                     , "--Low"      , "10"        -- units: %
                     , "--High"     , "80"        -- units: %
                     , "--low"      , "darkred"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkgreen"
                     , "--"
                     -- battery specific options
                     -- discharging status
                     , "-o"         , "<left>%"
                     -- AC "on" status
                     , "-O"	       , "<fc=#dAA520>Charging</fc>"
                     -- charged status
                     , "-i"	, "<fc=#006000>Charged</fc>"
                     ] 50

    -- network activity monitor (dynamic interface resolution)
    , Run DynNetwork [ "--template" , "Net: [<tx>kB/s <rx>kB/s]"
                     , "--Low"      , "1000"       -- units: B/s
                     , "--High"     , "5000"       -- units: B/s
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     ] 10

    -- cpu activity monitor
    , Run MultiCpu   [ "--template" , "CPU: [<total0>, <total1>, <total2>, <total3>]%"
                     , "--Low"      , "50"         -- units: %
                     , "--High"     , "85"         -- units: %
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     ] 10

      -- cpu core temperature monitor
    , Run CoreTemp   [ "--template" , "Temp: [<core0>°C <core1>°C]"
                     , "--Low"      , "70"        -- units: °C
                     , "--High"     , "80"        -- units: °C
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     ] 50

    -- memory usage monitor
    , Run Memory     [ "--template" ,"Mem: <usedratio>%"
                     , "--Low"      , "20"        -- units: %
                     , "--High"     , "90"        -- units: %
                     , "--low"      , "darkgreen"
                     , "--normal"   , "darkorange"
                     , "--high"     , "darkred"
                     ] 10

    -- , Run Com "~/.xmonad/get-volume" [] "myvolume" 10
    , Run Date "%a %b %d%l:%M:%S %p" "date" 10
    , Run StdinReader]
}
