breed [ teenagers teenager ]
breed [ adults adult ]
breed [ elders elder ]
turtles-own [ neighbours s dist x y infected-time quarantine-time hospital-time ICU-time house place ]
globals[ mu1 mu2 std1 std2 z1 z2 j k hosp1 hosp2 h-count1 h-count2]
to setup
  clear-all
  ask patches [ set pcolor black ]
  hospitals
   set h-count1 0
   set h-count2 0
  create-teenagers initial-number-teenagers  ; create teenagers, then initialize their variables
  [
    set shape  "person"
    set color blue
    set size 1.5  ; easier to see
    set label-color green + 2

    setxy random-xcor random-ycor
     if pcolor = orange or pcolor = cyan [move-to one-of patches with [pcolor = black]]
     set house patch-here
     ; set x xcor
      ;set y ycor
   set hospital-time 0
   set infected-time 0
   set quarantine-time 0
   set ICU-time 0
    ]

    create-adults initial-number-adults  ; create the adults, then initialize their variables
  [
    set shape  "person"
    set color pink
    set size 1.5  ; easier to see
    set label-color red + 2
    setxy random-xcor random-ycor
    if pcolor = orange or pcolor = cyan [move-to one-of patches with [pcolor = black]]
    set house patch-here
   set hospital-time 0
   set infected-time 0
   set quarantine-time 0
   set ICU-time 0 ]


  create-elders initial-number-elders  ; create the elders, then initialize their variables
  [
    set shape  "person"
    set color white
    set size 1.5  ; easier to see
    set label-color yellow + 2
    setxy random-xcor random-ycor
    if pcolor = orange or pcolor = cyan [move-to one-of patches with [pcolor = black]]
   set house patch-here
   set hospital-time 0
   set infected-time 0
    set quarantine-time 0
    set ICU-time 0]

  ask n-of 27 turtles [ set color brown ]
  reset-ticks
end

to go
  if ticks = 480 [ stop ]
  ask turtles[ infect
  asymptomatic
  quarantine
  hospitalize
  waitlist
  ICU]
  ask teenagers
  [
  if (color != yellow) and (color != magenta) and (color != lime) and (color != sky)
  [
      move-teenagers]
    if color = magenta [ move-to place]]
  ask adults
  [
  if (color != yellow) and (color != magenta) and (color != lime) and (color != sky)
  [
      move-adults]
  if color = magenta [ move-to place]]
  ask elders
  [
  if (color != yellow) and (color != magenta) and (color != lime) and (color != sky)
  [
    move-elders
  ]
  if (color = magenta) or (color = sky) [ move-to place]]
  count-neighbours-and-total-distance
  if ticks = 479 [
    set mu1 mean [ neighbours ] of turtles
    set std1 standard-deviation [ neighbours ] of turtles
    set z1 mu1 - std1
    set mu2 mean [ dist ] of turtles
    set std2 standard-deviation [ dist ] of turtles
    set z2 mu2 + std2
    write "Isolated Nodes:1"
    ask turtles
     [
      if neighbours < z1 [ show who
       set k k + 1 ]
     ]
     write "Isolated Nodes: 2"
     ask turtles [
     if dist > z2 [ show who
     set j j + 1 ]
     ]
     write " ISN "
     show k
     write " ISD "
     show j
     write " Total"
     show j + k
     ]
     tick
end

to hospitals
     ask patch -30 -32 [
    set pcolor orange
    ask neighbors [
    set pcolor orange
    ]
  ]
  ask patch 30 32 [
    set pcolor cyan
    ask neighbors [
    set pcolor cyan
    ]
  ]
  set hosp1 patches with [pcolor = cyan ]
 set hosp2 patches with [pcolor = orange ]
end
to move-teenagers
   ;if pcolor = orange or pcolor = cyan [move-to one-of patches with [pcolor = black]]
  ifelse remainder ticks 8 = 0 [ if ticks != 0 [ if random-float 1 <= 0.9
      [ ifelse patch-here = house [;;do nothing
        ][move-to house]
    ]]
    ]
    [ rt random 360
      fd 3.125 + random 1]
    if pcolor = orange or pcolor = cyan [move-to one-of patches with [pcolor = black]
    ]

end

to move-adults
  ifelse remainder ticks 8 = 0 [ if ticks != 0 [ if random-float 1 <= 0.9
      [
        ifelse patch-here = house [;;do nothing
        ][move-to house]
    ]]]
[     rt random 360
      fd 2.25 + random 1]
    if pcolor = orange or pcolor = cyan [move-to one-of patches with [pcolor = black]  ]

end

to move-elders
       ifelse remainder ticks 8 = 0 [ if ticks != 0 [ if random-float 1 <= 0.9
      [     ifelse patch-here = house [;; do nothing
        ] [ move-to house ]
    ]]]
[     rt random 360
      fd 1 + random 1.375]
    if (pcolor = orange)or (pcolor = cyan) [move-to one-of patches with [pcolor = black]  ]

end
to asymptomatic
    if color = brown [ if infected-time > 40 [ set color yellow
    ifelse patch-here = house[ ;;do nothing
    ][move-to house]
    ]]

    if color = brown [ set infected-time infected-time + 1 ]
end
to infect
  if (color = brown)
      [  ask other turtles-here [ if (color = blue) or (color = pink) or (color = white) [if random-float 1 <= 0.8 [set color brown ]]]]
end

to quarantine
  if color = yellow [if (quarantine-time > 0) and (quarantine-time) <= 72 [ifelse patch-here = house[ ;;do nothing
  ][move-to house]  ]]
  if color = yellow [ if quarantine-time > 72 [ ifelse random-float 1 <= 0.12 [set color magenta] [ set color turquoise ]]]
  if color = yellow [ if any? other turtles-here [ask other turtles with [color != yellow] [ move-to one-of patches with [pcolor = black]]]]
  if color = yellow [set quarantine-time quarantine-time + 1 ]
end

to hospitalize
  if (color = magenta) and (hospital-time = 0) [

    ifelse (h-count1 < 30)[
      move-to one-of patches with [pcolor = cyan]
      set h-count1 h-count1 + 1
      set place patch-here
       ][ifelse (h-count1 >= 30) and (h-count2 < 30)[
        move-to one-of patches with [pcolor = orange]
        set h-count2 h-count2 + 1
        set place patch-here ][set color lime]]]
  if (color = magenta)[ move-to place]
  if (color = magenta)[ if hospital-time > 40 [
    if ( pcolor = orange) [ set h-count2 h-count2 - 1]
    if ( pcolor = cyan) [ set h-count1 h-count1 - 1]
    ifelse random-float 1 <= 0.025[set color sky][ifelse random-float 1 <= 0.023 [ die] [ set color turquoise]]]]
  if (color = magenta) [ set hospital-time hospital-time + 1]
end
to waitlist
    if color = lime [ ifelse patch-here = house [;;do nothing
    ][move-to house]]
    if color = lime [ if any? other turtles-here with [color != lime and color != yellow] [ask other turtles[ move-to one-of patches with [pcolor = black]]]]
    if color = lime [ ifelse h-count1 < 30 and h-count2 < 30
      [ set color magenta
       move-to one-of patches with [pcolor = cyan or pcolor = orange]]
    [ ifelse (h-count1 < 30 and h-count2 >= 30) [set color magenta
        move-to one-of patches with [pcolor = cyan]] [ ifelse (h-count2 < 30 and h-count1 >= 30) [set color magenta
          move-to one-of patches with [pcolor = orange]][if random-float 1 <= 0.30[die]]]]]
end

to ICU
    if color = sky [if ICU-time > 56 [ifelse random-float 1 <= 0.30[ die ][set color turquoise ]]]
    if color = sky [set ICU-time ICU-time + 1]
end

to count-neighbours-and-total-distance
  ask teenagers
  [ ifelse (color != magenta) and (color != lime) and (color != sky) [set neighbours neighbours + count other turtles in-radius 20][]
    ifelse (color != magenta) and (color != lime) and (color != sky) [
    ask other turtles
    [ if distance myself <= 20 [ set s s + distance myself]]
    if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]] [ set s s + 30
    if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]]
  ]
  ask adults
  [
    ifelse (color != magenta) and (color != lime) and (color != sky) [set neighbours neighbours + count other turtles in-radius 20][set neighbours neighbours]
    ifelse (color != magenta) and (color != lime) and (color != sky) [
    ask other turtles
    [ if distance myself <= 20 [ set s s + distance myself]]
      if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]] [ set s s + 30
    if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]]
  ]
  ask elders
  [
    ifelse (color != magenta) and (color != lime) and (color != sky) [set neighbours neighbours + count other turtles in-radius 20][set neighbours neighbours]
    ifelse (color != magenta) and (color != lime) and (color != sky) [
  ask other turtles
    [ if distance myself <= 20 [ set s s + distance myself]]
      if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]] [ set s s + 30
    if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]]
  ]
end
