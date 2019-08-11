#lang racket/gui
(require data-frame map-widget mrlib/snip-canvas plot)
(provide load-map)


(define (load-map)
  (define toplevel (new frame% [label "Wazitico"] [width 600] [height 400]))
  (define map (new map-widget% [parent toplevel]))
  (send toplevel show #t)
  )

