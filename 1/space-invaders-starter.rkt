;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))


(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))



(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;;ListofInvaders
;;--empty
;;--(cons invader ListOfInvaders)
;;interp
(define LOI1 empty)
(define LOI2 (list I1))
(define LOI3 (list I2 I1))

(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (...
          (fn-for-invader (first loi))
          (fn-for-loi (rest loi)))
         ]))

;;ListOfMissles
;;--empty
;;--(cons missle ListOfMissles)
;;
(define LOM1 empty)
(define LOM2 (list M1))
(define LOM3 (list M1 M2))

(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]
        [else
         (...
          (fn-for-missle (first lom))
          (fn-for-lom (rest lom)))
         ]))

;;function to iniate the game(main (make-game empty empty (make-tank Number +-1)))
(define (main l)
  (big-bang l
    (on-tick next 0.1)
    (on-key key-handler)
    (to-draw render)))


;;Game ->Game
;;produce next state of the game
(check-expect (next G0) (make-game empty empty
                                   (make-tank (+ (tank-x T0) (* (tank-dir T0) (* 5 TANK-SPEED))) (tank-dir T0))))

(check-expect (next G1) (make-game empty empty
                                  (make-tank (+ (tank-x T1) (* (tank-dir T1) (* 5 TANK-SPEED))) (tank-dir T1))))
(define (next g)
  (filter (ticked (survived g))))
  ;(make-game (next-loi (game-invaders s)) ;;ListOfInvaders->ListOfInvaders
   ;    (next-lom (game-missiles s))       ;;ListOfMissles-> ListOfMissles
    ;   (next-tank (game-tank s))))          ;;Tank ->Tank


;;Game -> Game
;;produce game with left missles and invaders
(check-expect (survived G0) G0)
(check-expect (survived G1) (make-game empty empty T1))
(define (survived g)
  (make-game (survive-loi (game-invaders g) (game-missiles g))
             (survive-lom (game-invaders g) (game-missiles g));; ListOfInvaders ListOfMissiles ->ListOfMissiles
             (game-tank g)))


;; ListOfInvaders ListOfMissiles ->ListOfMissiles
(check-expect (survive-lom empty empty) empty)
(check-expect (survive-lom LOI2 LOM2) LOM2)
(check-expect (survive-lom LOI3 LOM3) (list M1))
;(define (survive-lom loi lom) empty);stub
(define (survive-lom loi lom)
  (cond [(empty? loi) lom]
        [(empty? lom) empty]
        [else
          (if (survive-missile (first lom) loi)
           (cons (first lom) (survive-lom loi (rest lom)))
           (survive-lom  loi (rest lom)))]))

;;Missile ListOfInvaders -> Boolean
(define (survive-missile m loi)
  (cond [(empty? loi) true]
        [else
         (if (hit? (first loi) m )
             false
          (survive-missile m (rest loi)))]))


;;ListOfInvaders ListOfMissiles-> ListOfInvaders
;;
(check-expect (survive-loi empty empty) empty)
(check-expect (survive-loi LOI2 LOM2) LOI2)
(check-expect (survive-loi LOI3 LOM3) (list I2))
(define (survive-loi loi lom)
  (cond [(empty? lom) loi]
        [(empty? loi) empty]
        [else
          (if (survive-invader (first loi) lom)
           (cons (first loi) (survive-loi (rest loi) lom))
           (survive-loi (rest loi) lom))]))

  
;;Invader ListOfMissles-> Boolean
;;
(define (survive-invader i lom)
  (cond [(empty? lom) true]
        [else
         (if (hit? i (first lom))
             false
          (survive-invader i (rest lom)))]))

;;invader missle->boolean
;;
(check-expect (hit? I1 M1) false)
(check-expect (hit? I1 M2) true)
(define (hit? i m)
 (and (or (< (- (invader-x i) (missile-x m)) 5) (> (- (invader-x i) (missile-x m)) -5))
           (<= (- (missile-y m) (invader-y i)) HIT-RANGE)
           (>= (missile-y m) (invader-y i))))
    
        
             
;Game -> Game
;;produce ticked game
(define (ticked g)
   (make-game (ticked-loi (game-invaders g)) ;;ListOfInvaders->ListOfInvaders
       (ticked-lom (game-missiles g))       ;;ListOfMissles-> ListOfMissles
       (ticked-tank (game-tank g))))          ;;Tank ->Tank

;;ListOfInvaders->ListOfInvaders
;;produce ticked ListOfInvaders
(define (ticked-loi loi)
  (cond [(empty? loi) empty]
        [else
         (cons
          (ticked-invader (first loi))
          (ticked-loi (rest loi)))
         ]))

;;Invader -> Invader
;;produce ticked invader
(check-expect (ticked-invader I1) (make-invader (+ (invader-x I1) (* INVADER-X-SPEED (invader-dx I1)))
                                                (+ (invader-y I1) INVADER-Y-SPEED)
                                                (invader-dx I1)))
(check-expect (ticked-invader (make-invader 299 300 10)) (make-invader 300
                                                            (+ 300 INVADER-Y-SPEED)
                                                            -10))
                                                            
;(define (ticked-invader t) I1);stub
(define (ticked-invader i)
  (cond [(and (<= (+ (invader-x i) (* INVADER-X-SPEED (invader-dx i))) WIDTH)
          (>= (+ (invader-x i) (* INVADER-X-SPEED (invader-dx i))) 0))
      (make-invader (+ (invader-x i) (* INVADER-X-SPEED (invader-dx i)))
                                                (+ (invader-y i) INVADER-Y-SPEED)
                                                (invader-dx i))]
        [(> (+ (invader-x i) (* INVADER-X-SPEED (invader-dx i))) WIDTH)
      (make-invader WIDTH
                    (+ (invader-y i) INVADER-Y-SPEED)
                     (- (invader-dx i)))]
        [else
         (make-invader 0
                    (+ (invader-y i) INVADER-Y-SPEED)
                     (- (invader-dx i)))]))
      

;;;;ListOfMissile->ListOfMissiles
;(check-expect (ticked-lom 
;(define (ticked-lom lom) LOM1);stub
(define (ticked-lom lom)
  (cond [(empty? lom) empty]
        [else
         (cons
          (ticked-missile (first lom))
          (ticked-lom (rest lom)))]))

;;Missile -> Missile
(define (ticked-missile m)
  (make-missile (missile-x m)
       (- (missile-y m) MISSILE-SPEED)))

;;Tank -> Tank
;(define (ticked-tank t) T0);stub
(define (ticked-tank t)
  (cond [(and (>= (+ (tank-x t) (* (tank-dir t) (* 5 TANK-SPEED))) 0)
        (<= (+ (tank-x t) (* (tank-dir t) (* 5 TANK-SPEED))) WIDTH))
         (make-tank (+ (tank-x t) (* (tank-dir t) (* 5 TANK-SPEED)))
                    (tank-dir t))]
        [(< (+ (tank-x t) (* (tank-dir t) (* 5 TANK-SPEED))) 0)
         (make-tank 0
                    (tank-dir t))]
        [else
         (make-tank WIDTH
                    (tank-dir t))]))
  

;;Game->Game
(define (filter g) g)


;;Game x  y keyevent -> Game
(check-expect (key-handler G0 "left") (make-game empty empty
                                                 (make-tank (/ WIDTH 2) -1)))
(check-expect (key-handler G2  " ") (make-game (game-invaders G2)
                                               (cons (make-missile (tank-x (game-tank G2))
                                                                   (- HEIGHT (* TANK-HEIGHT/2 2)))
                                                     (game-missiles G2))
                                               (game-tank G2)))
(check-expect (key-handler G2  "a") G2)
;(define (key-handler g ke) G0);stub
(define (key-handler g ke)
  (cond [(key=? ke "left")
         (make-game (game-invaders g)
                    (game-missiles g)
                    (make-tank (tank-x (game-tank g))  -1))]
        [(key=? ke "right")
         (make-game (game-invaders g)
                    (game-missiles g)
                    (make-tank (tank-x (game-tank g))   1))]
        [(key=? ke " ")
         (make-game (game-invaders g)
                    (cons (make-missile (tank-x (game-tank g)) (- HEIGHT (* TANK-HEIGHT/2 2)))
                          (game-missiles g))
                    (game-tank g))]
        [else g]
        ))

;;Game -> Image
(check-expect (render G0) (place-image TANK (tank-x T0) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))
;(define (render g) BACKGROUND)
(define (render g)
  (render-invaders (game-invaders g)
       (render-missiles (game-missiles g)
       (render-tank (game-tank g)))))

;;Tank -> Image
(check-expect (render-tank T0) (place-image TANK (tank-x T0) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))
;(define (render-tank t) TANK);stub
(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;;ListOfMissiles Image -> Image
(check-expect (render-missiles LOM1 BACKGROUND) BACKGROUND)
(check-expect (render-missiles LOM2 BACKGROUND) (place-image MISSILE (missile-x M1) (missile-y M1) BACKGROUND))
(check-expect (render-missiles LOM3 BACKGROUND) (place-image MISSILE (missile-x M2) (missile-y M2)
                                                             (place-image MISSILE (missile-x M1) (missile-y M1) BACKGROUND)))
;(define (render-missiles lom img) img);stub
(define (render-missiles lom img)
  (cond [(empty? lom) img]
        [else
         (place-image
          MISSILE
          (missile-x (first lom))
          (missile-y (first lom))
          (render-missiles (rest lom) img))]
        ))

;;ListOfInvaders Image -> Image
(check-expect (render-invaders LOI1 BACKGROUND) BACKGROUND)
(check-expect (render-invaders LOI2 BACKGROUND) (place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND))
(check-expect (render-invaders LOI3 BACKGROUND) (place-image INVADER (invader-x I2) (invader-y I2)
                                                             (place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND)))
;(define (render-invaders loi img) img);stub
(define (render-invaders lom img)
  (cond [(empty? lom) img]
        [else
         (place-image
          INVADER
          (invader-x (first lom))
          (invader-y (first lom))
          (render-invaders (rest lom) img))]
        ))