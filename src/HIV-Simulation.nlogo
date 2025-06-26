globals [
  infection-chance  ;; The chance out of 100 that an infected person will pass on
                    ;;   infection during one week of couplehood.
  symptoms-show     ;; How long a person will be infected before symptoms occur
                    ;;   which may cause the person to get tested.
  slider-check-1    ;; Temporary variables for slider values, so that if sliders
  slider-check-2    ;;   are changed on the fly, the model will notice and
  slider-check-3    ;;   change people's tendencies appropriately.
  slider-check-4
  slider-check-5
  slider-check-6
  current-ticks
]

turtles-own [
  gender             ;; 0 for male, 1 for female
  drugs?             ;; If true, the person uses drugs.
  infected?          ;; If true, the person is infected.  It may be known or unknown.
  known?             ;; If true, the infection is known (and infected? must also be true).
  treated?           ;; If true, the person gets treatment.
  infection-length   ;; How long the person has been infected.
  coupled?           ;; If true, the person is in a sexually active couple.
  couple-length      ;; How long the person has been in a couple.
  partner            ;; The person that is our current partner in a couple.
  ;; the next six values are controlled by sliders
  commitment         ;; How long the person will stay in a couple-relationship.
  coupling-tendency  ;; How likely the person is to join a couple.
  condom-use         ;; The percent chance a person uses protection.
  test-frequency     ;; Number of times a person will get tested per year.
  treatment-tendency ;; How likely a person is to get treatment.
  drug-tendency      ;; The percent chance a person does drugs.
]

;;;
;;; SETUP PROCEDURES
;;;

to setup
  clear-all
  setup-globals
  setup-people
  reset-ticks
end

to setup-globals
  set infection-chance 2   ;; if you have unprotected sex with an infected partner,
                             ;; you have a 2% chance of being infected
  set symptoms-show 1400.0    ;; symptoms show up 1400 days after infection
  set slider-check-1 average-commitment
  set slider-check-2 average-coupling-tendency
  set slider-check-3 average-condom-use
  set slider-check-4 average-test-frequency
  set slider-check-5 average-drug-tendency
  set slider-check-6 average-treatment-tendency
end

;; Create carrying-capacity number of people half are righty and half are lefty
;;   and some are sick.  Also assigns colors to people with the ASSIGN-COLORS routine.

to setup-people
  create-turtles initial-people
    [ setxy random-xcor random-ycor
      set known? false
      set coupled? false
      set partner nobody
      set treated? false
      set gender random 2 ; 0 for male, 1 for female
      ifelse random 2 = 0
        [ set shape "person righty" ]
        [ set shape "person lefty" ]
      if gender = 1
        [ set shape "person woman" ]
      ;; 8% of the people start out infected, but they don't know it
       set infected? (who < initial-people * 0.08)
      if infected?
        [ set infection-length random-float symptoms-show ]
      assign-commitment
      assign-coupling-tendency
      assign-condom-use
      assign-test-frequency
      assign-treatment-tendency
      assign-drug-tendency
      ifelse drug-tendency > 5
        [ set drugs? true ]
        [ set drugs? false ]
      ;; 1.25% of the people start out using drugs, but they don't know it
      set drugs? (who < initial-people * 0.0925) and not infected?
      if drugs?
        [ set drug-tendency 5 ]
      assign-color ]

end

;; Different people are displayed in 5 different colors depending on health
;; green is not infected
;; yellow is not infected but do drugs
;; blue is infected but doesn't know it
;; red is infected and knows it
;; orange is infected and gets treatment

to assign-color  ;; turtle procedure
  ifelse not infected?
    [ set color green ]
      [ ifelse known?
        [ set color red ]
        [ set color blue ] ]
  if drugs? and not infected?
    [set color yellow]
  if treated?
    [ set color orange ]
end

to assign-commitment  ;; turtle procedure
  set commitment random-near average-commitment
end

to assign-coupling-tendency  ;; turtle procedure
  set coupling-tendency random-near average-coupling-tendency
end

to assign-condom-use  ;; turtle procedure
  set condom-use random-near average-condom-use
end

to assign-test-frequency  ;; turtle procedure
  set test-frequency random-near average-test-frequency
end

to assign-drug-tendency ;; turtle procedure
  set drug-tendency random-near average-drug-tendency
end

to assign-treatment-tendency ;; turtle procedure
  set treatment-tendency random-near average-treatment-tendency
end

to-report random-near [center]  ;; turtle procedure
  let result 0
  repeat 40
    [ set result (result + random-float center) ]
  report result / 20
end

;;;
;;; GO PROCEDURES
;;;

to go
  if all? turtles [known?]
    [ stop ]
  if (count turtles with [infected?]) = (count turtles with [treated?])
    [ stop ]
  check-sliders
  ask turtles
    [ if infected?
        [ set infection-length infection-length + 1 ]
      if coupled?
        [ set couple-length couple-length + 1 ] ]
  ask turtles
    [ if not coupled?
        [ move ] ]
  ;; Righties are always the ones to initiate mating.
  ask turtles
    [ if not coupled? and shape = "person righty" and (random-float 10.0 < coupling-tendency)
        [ couple ] ]
  ask turtles [ uncouple ]
  ask turtles [ infect ]
  ask turtles [ test ]
  ask turtles [ treat ]
  ask turtles [ assign-color ]
  tick
  set current-ticks ticks
end

;; Each tick a check is made to see if sliders have been changed.
;; If one has been, the corresponding turtle variable is adjusted

to check-sliders
  if (slider-check-1 != average-commitment)
    [ ask turtles [ assign-commitment ]
      set slider-check-1 average-commitment ]
  if (slider-check-2 != average-coupling-tendency)
    [ ask turtles [ assign-coupling-tendency ]
      set slider-check-2 average-coupling-tendency ]
  if (slider-check-3 != average-condom-use)
    [ ask turtles [ assign-condom-use ]
      set slider-check-3 average-condom-use ]
  if (slider-check-4 != average-test-frequency )
    [ ask turtles [ assign-test-frequency ]
      set slider-check-4 average-test-frequency ]
  if (slider-check-5 != average-drug-tendency )
    [ ask turtles [ assign-drug-tendency ]
      set slider-check-5 average-drug-tendency ]
  if (slider-check-6 != average-treatment-tendency)
    [ ask turtles [assign-treatment-tendency ]
      set slider-check-6 average-treatment-tendency ]
end

;; People move about at random.

to move  ;; turtle procedure
  rt random-float 360
  fd 1
end

;; The patches below turn gray if two agents are in a sexual relationship.

to couple  ;; turtle procedure -- righties only!
  let potential-partner one-of (turtles-at -1 0)
                          with [not coupled? and (shape = "person lefty" or shape = "person woman")]
  if potential-partner != nobody
    [ if random-float 10.0 < [coupling-tendency] of potential-partner
      [ set partner potential-partner
        set coupled? true
        ask partner [ set coupled? true ]
        ask partner [ set partner myself ]
        move-to patch-here ;; move to center of patch
        ask potential-partner [move-to patch-here] ;; partner moves to center of patch
        set pcolor gray - 3
        ask (patch-at -1 0) [ set pcolor gray - 3 ] ] ]
end

;; If two peoples are together for longer than either person's commitment variable
;; allows, the couple breaks up.

to uncouple  ;; turtle procedure
  if coupled? and (shape = "person righty")
    [ if (couple-length > commitment) or
         ([couple-length] of partner) > ([commitment] of partner)
        [ set coupled? false
          set couple-length 0
          ask partner [ set couple-length 0 ]
          set pcolor black
          ask (patch-at -1 0) [ set pcolor black ]
          ask partner [ set partner nobody ]
          ask partner [ set coupled? false ]
          set partner nobody ] ]
end

;; Infection can occur if either agent is infected.
;; The use of condom only has an 80% effectiveness.
;; The uninfected agents who do drugs have a chance of infection
;; if a number of agents who do drugs gets uninfected.

to infect  ;; turtle procedure
  if coupled? and infected? and not known?
    [ if random-float 10 > (0.8 * condom-use) or
         random-float 10 > (0.8 * ([condom-use] of partner))
        [ if random-float 100 < infection-chance
            [ ask partner [ set infected? true ] ] ] ]
  ;; Add 1 to condom-use if known?
  if coupled? and infected? and known? and not treated?
    [ if random-float 10 > (0.8 * (condom-use + 1)) or
         random-float 10 > (0.8 * ([condom-use + 1] of partner))
        [ if random-float 100 < infection-chance
            [ ask partner [ set infected? true ] ] ] ]
  ;; If treated, randomize float to lower infection chance (not sure sa 20)
  if coupled? and infected? and known? and treated?
    [ if random-float 10 > (0.8 * (condom-use + 1)) or
         random-float 10 > (0.8 * ([condom-use + 1] of partner))
        [ if random-float 100 < (infection-chance - random-float 20)
            [ ask partner [ set infected? true ] ] ] ]
  if drugs? and not infected?
    [ if random-float 1 > ((count turtles with [infected? = true and drugs? = true]) * 0.1)
      [ set infected? true ] ]
end

;; After being infected for some amount of time called SYMPTOMS-SHOW,
;; there is a 5% chance that the person will become ill and
;; be tested even without the tendency to check.

to test  ;; turtle procedure
  if current-ticks > 1
    [ if test-frequency = 1
      [if current-ticks mod 365 = 0
        [ if infected?
          [ set known? true ] ] ]
  if current-ticks > 1
    [ if test-frequency = 2
      [if current-ticks mod 183 = 0
        [ if infected?
            [ set known? true ] ] ] ] ]
  if (infection-length > symptoms-show)
    [ if random-float 100 < 10
        [ if infected?
        [ set known? true ] ] ]
  if partner != nobody
     [ if [known?] of partner
        [ if random-float 100 < 10
          [ if infected?
            [ set known? true ] ] ] ]
end

;; If an agent treatment-tendecy is 50%,
;; it will get treatment if it knows that they are infected.

to treat  ;; turtle procedure
  if treatment-tendency > 5
    [ if known?
        [ set treated? true ] ]
  if (infection-length > symptoms-show)
    [ if random-float 100 < 50
        [ set treatment-tendency (treatment-tendency + 1) ] ]
end
@#$#@#$#@
GRAPHICS-WINDOW
529
10
1010
492
-1
-1
18.92
1
10
1
1
1
0
1
1
1
-12
12
-12
12
1
1
1
days
30.0

BUTTON
12
81
95
114
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
96
81
179
114
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
278
205
358
250
infected
count turtles with [infected?]
2
1
11

SLIDER
7
37
276
70
initial-people
initial-people
0
10000
5000.0
50
1
NIL
HORIZONTAL

SLIDER
7
162
276
195
average-commitment
average-commitment
1
1400
266.0
1
1
days
HORIZONTAL

SLIDER
7
127
276
160
average-coupling-tendency
average-coupling-tendency
0
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
7
197
276
230
average-condom-use
average-condom-use
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
7
232
276
265
average-test-frequency
average-test-frequency
0
2
1.0
1
1
times/year
HORIZONTAL

SLIDER
7
264
276
297
average-drug-tendency
average-drug-tendency
0
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
7
297
276
330
average-treatment-tendency
average-treatment-tendency
0
10
5.0
1
1
NIL
HORIZONTAL

MONITOR
362
204
449
249
treated
count turtles with [treated?]
2
1
11

MONITOR
414
254
526
299
drugs
count turtles with [drugs?]
17
1
11

MONITOR
451
204
523
249
known
count turtles with [known?]
17
1
11

MONITOR
278
255
410
300
not known
count turtles with [infected? and not known?]
17
1
11

MONITOR
446
353
525
398
HIV woman
count turtles with [gender = 1 and infected?]
17
1
11

MONITOR
362
354
441
399
HIV man (R)
count turtles with [shape = \"person righty\" and infected?]
17
1
11

MONITOR
276
353
356
398
HIV man (L)
count turtles with [shape = \"person lefty\" and infected?]
17
1
11

MONITOR
277
305
420
350
infected and uses drugs
count turtles with [infected? and drugs?]
17
1
11

MONITOR
277
403
337
448
woman
count turtles with [gender = 1]
17
1
11

MONITOR
343
403
400
448
man
count turtles with [gender = 0]
17
1
11

MONITOR
406
404
463
449
Lefty
count turtles with [shape = \"person lefty\"]
17
1
11

MONITOR
469
404
526
449
Righty
count turtles with [shape = \"person righty\"]
17
1
11

MONITOR
425
304
525
349
treated-known
count turtles with [treated? and known?]
17
1
11

PLOT
279
10
524
200
Infected, Treated, Tested 
Days
Population
0.0
1000.0
0.0
1000.0
true
false
"" ""
PENS
"infected" 1.0 0 -13345367 true "" "plot count turtles with [infected?]"
"tested" 1.0 0 -5298144 true "" "plot count turtles with [known?]"
"treated" 1.0 0 -955883 true "plot count turtles with [treated?]" "plot count turtles with [treated?]"

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

person lefty
false
0
Circle -7500403 true true 170 5 80
Polygon -7500403 true true 165 90 180 195 150 285 165 300 195 300 210 225 225 300 255 300 270 285 240 195 255 90
Rectangle -7500403 true true 187 79 232 94
Polygon -7500403 true true 255 90 300 150 285 180 225 105
Polygon -7500403 true true 165 90 120 150 135 180 195 105

person righty
false
0
Circle -7500403 true true 50 5 80
Polygon -7500403 true true 45 90 60 195 30 285 45 300 75 300 90 225 105 300 135 300 150 285 120 195 135 90
Rectangle -7500403 true true 67 79 112 94
Polygon -7500403 true true 135 90 180 150 165 180 105 105
Polygon -7500403 true true 45 90 0 150 15 180 75 105

person woman
false
0
Circle -7500403 true true 170 5 80
Polygon -8630108 true false 165 90 180 195 150 285 165 300 195 300 210 225 225 300 255 300 270 285 240 195 255 90
Rectangle -7500403 true true 187 79 232 94
Polygon -7500403 true true 255 90 300 150 285 180 225 105
Polygon -7500403 true true 165 90 120 150 135 180 195 105
Polygon -2064490 true false 150 195 270 195 285 240 135 240 150 195

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="average-commitment" repetitions="25" sequentialRunOrder="false" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [treated?]</metric>
    <metric>count turtles with [infected?]</metric>
    <metric>count turtles with [drugs?]</metric>
    <metric>count turtles with [known?]</metric>
    <metric>count turtles with [infected? and not known?]</metric>
    <metric>count turtles with [gender = 1 and infected?]</metric>
    <metric>count turtles with [shape = "person lefty" and infected?]</metric>
    <metric>count turtles with [shape = "person righty" and infected?]</metric>
    <metric>count turtles with [infected? and drugs?]</metric>
    <metric>count turtles with [gender = 1]</metric>
    <metric>count turtles with [gender = 0]</metric>
    <metric>count turtles with [shape = "person lefty"]</metric>
    <metric>count turtles with [shape = "person righty"]</metric>
    <enumeratedValueSet variable="average-coupling-tendency">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-drug-tendency">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-test-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-condom-use">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-people">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-treatment-tendency">
      <value value="4"/>
    </enumeratedValueSet>
    <steppedValueSet variable="average-commitment" first="0" step="280" last="1400"/>
  </experiment>
  <experiment name="treatment-tendency" repetitions="25" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [treated?]</metric>
    <metric>count turtles with [infected?]</metric>
    <metric>count turtles with [drugs?]</metric>
    <metric>count turtles with [known?]</metric>
    <metric>count turtles with [infected? and not known?]</metric>
    <metric>count turtles with [gender = 1 and infected?]</metric>
    <metric>count turtles with [shape = "person lefty" and infected?]</metric>
    <metric>count turtles with [shape = "person righty" and infected?]</metric>
    <metric>count turtles with [infected? and drugs?]</metric>
    <metric>count turtles with [gender = 1]</metric>
    <metric>count turtles with [gender = 0]</metric>
    <metric>count turtles with [shape = "person lefty"]</metric>
    <metric>count turtles with [shape = "person righty"]</metric>
    <enumeratedValueSet variable="average-coupling-tendency">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-drug-tendency">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-test-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-condom-use">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-people">
      <value value="10000"/>
    </enumeratedValueSet>
    <steppedValueSet variable="average-treatment-tendency" first="0" step="2" last="10"/>
    <enumeratedValueSet variable="average-commitment">
      <value value="523"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Base experiment" repetitions="25" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [treated?]</metric>
    <metric>count turtles with [infected?]</metric>
    <metric>count turtles with [drugs?]</metric>
    <metric>count turtles with [known?]</metric>
    <metric>count turtles with [infected? and not known?]</metric>
    <metric>count turtles with [gender = 1 and infected?]</metric>
    <metric>count turtles with [shape = "person lefty" and infected?]</metric>
    <metric>count turtles with [shape = "person righty" and infected?]</metric>
    <metric>count turtles with [infected? and drugs?]</metric>
    <metric>count turtles with [gender = 1]</metric>
    <metric>count turtles with [gender = 0]</metric>
    <metric>count turtles with [shape = "person lefty"]</metric>
    <metric>count turtles with [shape = "person righty"]</metric>
    <runMetricsCondition>ticks mod 365 = 0</runMetricsCondition>
    <enumeratedValueSet variable="average-coupling-tendency">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-drug-tendency">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-test-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-condom-use">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-people">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-treatment-tendency">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-commitment">
      <value value="523"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="condom-use" repetitions="25" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [treated?]</metric>
    <metric>count turtles with [infected?]</metric>
    <metric>count turtles with [drugs?]</metric>
    <metric>count turtles with [known?]</metric>
    <metric>count turtles with [infected? and not known?]</metric>
    <metric>count turtles with [gender = 1 and infected?]</metric>
    <metric>count turtles with [shape = "person lefty" and infected?]</metric>
    <metric>count turtles with [shape = "person righty" and infected?]</metric>
    <metric>count turtles with [infected? and drugs?]</metric>
    <metric>count turtles with [gender = 1]</metric>
    <metric>count turtles with [gender = 0]</metric>
    <metric>count turtles with [shape = "person lefty"]</metric>
    <metric>count turtles with [shape = "person righty"]</metric>
    <enumeratedValueSet variable="average-coupling-tendency">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-drug-tendency">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-test-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="average-condom-use" first="0" step="2" last="10"/>
    <enumeratedValueSet variable="initial-people">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-treatment-tendency">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-commitment">
      <value value="523"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test-frequency" repetitions="25" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [treated?]</metric>
    <metric>count turtles with [infected?]</metric>
    <metric>count turtles with [drugs?]</metric>
    <metric>count turtles with [known?]</metric>
    <metric>count turtles with [infected? and not known?]</metric>
    <metric>count turtles with [gender = 1 and infected?]</metric>
    <metric>count turtles with [shape = "person lefty" and infected?]</metric>
    <metric>count turtles with [shape = "person righty" and infected?]</metric>
    <metric>count turtles with [infected? and drugs?]</metric>
    <metric>count turtles with [gender = 1]</metric>
    <metric>count turtles with [gender = 0]</metric>
    <metric>count turtles with [shape = "person lefty"]</metric>
    <metric>count turtles with [shape = "person righty"]</metric>
    <enumeratedValueSet variable="average-coupling-tendency">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-drug-tendency">
      <value value="0.1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="average-test-frequency" first="0" step="1" last="2"/>
    <enumeratedValueSet variable="average-condom-use">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-people">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-treatment-tendency">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-commitment">
      <value value="523"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="drug-tendency" repetitions="25" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [treated?]</metric>
    <metric>count turtles with [infected?]</metric>
    <metric>count turtles with [drugs?]</metric>
    <metric>count turtles with [known?]</metric>
    <metric>count turtles with [infected? and not known?]</metric>
    <metric>count turtles with [gender = 1 and infected?]</metric>
    <metric>count turtles with [shape = "person lefty" and infected?]</metric>
    <metric>count turtles with [shape = "person righty" and infected?]</metric>
    <metric>count turtles with [infected? and drugs?]</metric>
    <metric>count turtles with [gender = 1]</metric>
    <metric>count turtles with [gender = 0]</metric>
    <metric>count turtles with [shape = "person lefty"]</metric>
    <metric>count turtles with [shape = "person righty"]</metric>
    <enumeratedValueSet variable="average-coupling-tendency">
      <value value="3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="average-drug-tendency" first="0" step="2" last="10"/>
    <enumeratedValueSet variable="average-test-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-condom-use">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-people">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-treatment-tendency">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-commitment">
      <value value="523"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="coupling-tendency" repetitions="25" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles with [treated?]</metric>
    <metric>count turtles with [infected?]</metric>
    <metric>count turtles with [drugs?]</metric>
    <metric>count turtles with [known?]</metric>
    <metric>count turtles with [infected? and not known?]</metric>
    <metric>count turtles with [gender = 1 and infected?]</metric>
    <metric>count turtles with [shape = "person lefty" and infected?]</metric>
    <metric>count turtles with [shape = "person righty" and infected?]</metric>
    <metric>count turtles with [infected? and drugs?]</metric>
    <metric>count turtles with [gender = 1]</metric>
    <metric>count turtles with [gender = 0]</metric>
    <metric>count turtles with [shape = "person lefty"]</metric>
    <metric>count turtles with [shape = "person righty"]</metric>
    <steppedValueSet variable="average-coupling-tendency" first="0" step="2" last="10"/>
    <enumeratedValueSet variable="average-drug-tendency">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-test-frequency">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-condom-use">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-people">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-treatment-tendency">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-commitment">
      <value value="523"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
