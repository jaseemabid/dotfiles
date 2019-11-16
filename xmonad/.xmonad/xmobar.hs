Config {
    -- Needs font awesome version 4.7.0 for all the glyphs. v5 changed name of
    -- the font and only contains some of the glyphs.
    font = "xft:Droid Sans Mono:size=16,FontAwesome:size=15:antialias=true"
  , bgColor = "#2E3440"
  , fgColor = "#D8DEE9"
  , position = Bottom x
  , sepChar = "%"
  , allDesktops = True
  , alignSep = "}{"
  , template = " %StdinReader% }{ %dynnetwork% %multicpu% %memory% %bright% %volume% %coretemp% %battery% %date%"
  , commands = [
    Run Brightness   ["--template"  , " <percent>%"
                     , "--"
                     , "--device"   ,  "intel_backlight"] 10

    -- battery monitor
  , Run Battery      [ "--template" , " <acstatus>"
                     , "--Low"      , "10"        -- units: %
                     , "--High"     , "80"        -- units: %
                     , "--low"      , "#bf616a"
                     , "--normal"   , "#d08770"
                     , "--high"     , "#a3be8c"
                     , "--"
                     -- battery specific options
                     -- discharging status
                     , "-o"         , "<left>%"
                     -- AC "on" status
                     , "-O"         , "<left>% <fc=#5e81ac></fc>"
                     -- charged status
                     , "-i"         , "<left>% <fc=#8fbcbb></fc>"
                     ] 10

    -- network activity monitor (dynamic interface resolution)
    --
    -- Fontawesome uses unicode points OxF062 and OxF063 for the arrows but the
    -- chars are invalid.
    , Run DynNetwork [ "--template" , "  <rx>  <tx> kB/s"] 10

    -- cpu activity monitor
    , Run MultiCpu   [ "--template" , " <total>%"
                     , "--Low"      , "50"         -- units: %
                     , "--High"     , "85"         -- units: %
                     , "--low"      , "#a3be8c"
                     , "--normal"   , "#d08770"
                     , "--high"     , "#bf616a"
                     , "-p"         , "2"
                     ] 10

      -- cpu core temperature monitor
    , Run CoreTemp   [ "--template" , " <core0>°C"
                     , "--Low"      , "70"        -- units: °C
                     , "--High"     , "80"        -- units: °C
                     , "--low"      , "#a3be8c"
                     , "--normal"   , "#d08770"
                     , "--high"     , "#bf616a"
                     ] 100

    -- memory usage monitor
    , Run Memory     [ "--template" ," <usedratio>%"
                     , "--Low"      , "20"        -- units: %
                     , "--High"     , "90"        -- units: %
                     , "--low"      , "#a3be8c"
                     , "--normal"   , "#d08770"
                     , "--high"     , "#bf616a"
                     ] 10

    , Run Com "volume" [] "" 10
    , Run Date " %a %b %d  %l:%M:%S %p " "date" 10
    , Run StdinReader]
}
