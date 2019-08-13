#lang racket/gui
(require 2htdp/image)
(require data-frame map-widget mrlib/snip-canvas)
(provide runner)

#|*********************************************************UI DEFINITIONS*********************************************************|#

;Window Definitions
(define  mainScreen (new frame% [label "Wazitico | Home"] [width 1000] [height 700]))
(define infoScreen (new frame% [label "Wazitico | Info"] [width 1000] [height 700]))

;Load media
(define app_icon (make-object bitmap% "img/ic_launcher.png"))
(define (runAssets canvas dc) (send dc set-scale 0.4 0.4) (send dc draw-bitmap app_icon 10 0))

;(mainScreen -> infoScreen) 
(define toInfoScreen_btn (new button% [parent mainScreen] [label app_icon] [callback (lambda (button event) (toinfoScreen))]))
(define (toinfoScreen) (send  mainScreen show #f) (send infoScreen show #t))

;(infoScreen -> mainScreen) 
(define toMainScreen_btn (new button% [parent infoScreen] [label "BACK"] [callback (lambda (button event) (toMainScreen))]))
(define (toMainScreen) (send  mainScreen show #t) (send infoScreen show #f))


#|**********************************************************MAP FUNCTIONS*********************************************************|#

;Load map from openStreetMap using map-widget
(define (load-map)
  (define map (new map-widget% [parent mainScreen]))
  (send mainScreen show #t)
  )

;Run Main Application
(define (runner bool)
  (cond ((equal? bool #t)
         (send mainScreen show #t)
         (load-map))
        (else
         (send mainScreen show #f))))




