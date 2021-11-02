breed [ adults adult ]
breed [ elders elder ]
turtles-own [ neighbours s dist x y infected-time quarantine-time hospital-time ICU-time house place prob mylist]
globals[ mu1 mu2 std1 std2 z1 z2 j k hosp1 hosp2 h-count1 h-count2]
to setup
  clear-all
  ask patches [ set pcolor black ]
   create-adults initial-number-adults  ; create the adults, then initialize their variables
  [
    set shape  "person"
    set color pink
    set size 1.5  ; easier to see
    set label-color red + 2
    setxy random-xcor random-ycor
    set prob 0.1 + random-float 0.9
    set house patch-here
  ]

  create-elders initial-number-elders  ; create the elders, then initialize their variables
  [
    set shape  "person"
    set color white
    set size 1.5  ; easier to see
    set label-color yellow + 2
    set prob 0.1 + random-float 0.7
    setxy random-xcor random-ycor
   set house patch-here
  ]
  reset-ticks
end

to go
  if ticks = 480 [ stop ]
  ask adults
  [
      move-adults]
  ask elders
  [
    move-elders
  ]
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


to move-adults
  ifelse remainder ticks 8 = 0 [ if ticks != 0 [ if random-float 1 <= 0.9
      [
        ifelse patch-here = house [;;do nothing
        ][move-to house]
    ]]]
[     rt random 360
      fd 2.25 + random 1]
   ; if pcolor = orange or pcolor = cyan [move-to one-of patches with [pcolor = black]  ]

end

to move-elders
       ifelse remainder ticks 8 = 0 [ if ticks != 0 [ if random-float 1 <= 0.9
      [     ifelse patch-here = house [;; do nothing
        ] [ move-to house ]
    ]]]
[     rt random 360
      fd 1 + random 1.375]
    ;if (pcolor = orange)or (pcolor = cyan) [move-to one-of patches with [pcolor = black]  ]

end

to count-neighbours-and-total-distance
  ask adults
  [
    ask other turtles
    [ if distance myself <= 20 [if random-float 1 >= prob[ set neighbours neighbours + 1
      set s s + distance myself]]]
      if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]] ;[ set s s + 30
  ask elders
  [
  ask other turtles
    [ if distance myself <= 20 [ if random-float 1 >= prob[set neighbours neighbours + 1
      set s s + distance myself]]]
      if neighbours = 0 [ set dist dist ]
      if neighbours != 0 [ set dist dist + s / neighbours ]] ;[ set s s + 30
end
