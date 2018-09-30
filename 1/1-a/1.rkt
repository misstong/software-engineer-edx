;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(beside (overlay (text "Sun" 11 "black")
                 (crop 200 0 150 300 (circle 150 "solid" "yellow"))
                 )
        (circle 10 "solid" "transparent")
        (above
                (circle 8 "solid" (make-color 147 149 152))
                (circle 5 "solid" "transparent")
                (text "Mercury" 11 "white"))
        (circle 10 "solid" "transparent")
        (above
                (circle 12 "solid" (make-color 215 223 35))
                (circle 5 "solid" "transparent")
                (text "Venus" 11 "white"))
        (circle 10 "solid" "transparent")
        (above
                (circle 15 "solid" (make-color 0 174 239))
                (circle 5 "solid" "transparent")
                (text "Earth" 11 "white"))
        (circle 10 "solid" "transparent")
        (above
                (circle 10 "solid" (make-color 190 30 45))
                (circle 5 "solid" "transparent")
                (text "Mars" 11 "white"))
        (circle 10 "solid" "transparent")
        (above
         (beside
          (circle 3 "solid" "brown")
          (circle 3 "solid" "transparent"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "transparent")
          (circle 3 "solid" "brown"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "brown")
          (circle 3 "solid" "transparent"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "transparent")
          (circle 3 "solid" "brown"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "brown")
          (circle 3 "solid" "transparent"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "transparent")
          (circle 3 "solid" "brown"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "brown")
          (circle 3 "solid" "transparent"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "transparent")
          (circle 3 "solid" "brown"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "brown")
          (circle 3 "solid" "transparent"))
         (circle 5 "solid" "transparent")
         (beside
          (circle 3 "solid" "transparent")
          (circle 3 "solid" "brown"))
         (circle 5 "solid" "transparent")
         (text "Asteroid Belt" 11 "white"))
        (circle 10 "solid" "transparent")
        (above
               (circle 60 "solid" (make-color 247 148 29))
               (circle 5 "solid" "transparent")
               (text "Jupiter" 11 "white"))
        (circle 20 "solid" "transparent")
            (above
             (rotate 45
               (overlay/align "left" "middle"
                (crop 0 0 45 90 (circle 45 "solid" (make-color 255 242 0)))
                (overlay
                 (ellipse 20 160 "outline" "white")
                 (circle 45 "solid" (make-color 255 242 0)))))
               (circle 5 "solid" "transparent")
               (text "Saturn" 11 "white"))
        (circle 20 "solid" "transparent")
        (above
                (circle 34 "solid" (make-color 0 167 157))
                (circle 5 "solid" "transparent")
                (text "Uranus" 11 "white"))
        (circle 20 "solid" "transparent")
        (above
                (circle 5 "solid" (make-color 196 154 108))
                (circle 5 "solid" "transparent")
                (text "Pluto" 11 "white")
                (text "(No longer a planet)" 11 "white"))
)