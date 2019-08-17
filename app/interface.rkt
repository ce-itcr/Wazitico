#lang racket/gui

(require racket/draw simple-svg)
(require "../src/pathfind/finder.rkt")
(provide runner)


#|****************************************************GLOBAL UI DEFINITIONS****************************************************|#

;;Colors
(define black (make-object color% "black"))
(define white (make-object color% "white"))
(define red (make-object color% "red"))
(define gray (make-object color% "gray"))

;;Pens and their colors
(define red-drawing-pen   (make-object pen% red 4 'solid))
(define gray-drawing-pen (make-object pen% gray 4 'solid))
(define red-brush    (instantiate brush% ("RED" 'solid)))
(define  gray-brush    (instantiate brush% ("GRAY" 'solid)))

;;Interface Variable Definition
(define (xypos-hash f h) (make-immutable-hash (hash-map h (lambda (k v)(cons k (f v))))))
(define counter 0)

;;Windows and Interface Panels
(define window (new frame% [label "Wazitico"] [width 1200] [height 700]))
(define row (new horizontal-panel% [parent window] [style '(border)] [alignment '(center center)]))
(define left-column (new vertical-panel% [parent row] [style '(border)] [alignment '(center center)]))
(define center-column (new vertical-panel% [parent row] [style '(border)] [alignment '(center center)]))
(define right-column (new vertical-panel% [parent row] [style '(border)][alignment '(center center)]))


#|**************************************************RIGHT COLUMN DEFINITIONS***************************************************|#

;;Interaction spaces in right panel : Add Nodes
(define name-field
  (new text-field% [parent right-column] [label "Name:"]))
(define x-field
  (new text-field% [parent right-column] [label "X Pos:"]))
(define y-field
  (new text-field% [parent right-column] [label "Y Pos:"]))
(define to-box
  (new text-field% [parent right-column] [label "To:"]))

;;Interaction spaces in right panel : Find Paths
(define src-field
  (new text-field% [parent right-column] [label "SRC"]))
(define dest-field
  (new text-field% [parent right-column] [label "DEST"]))

;;Interaction spaces in right panel : Join Nodes
(define from-field
  (new text-field% [parent right-column] [label "FROM"]))
(define to-field
  (new text-field% [parent right-column] [label "TO"]))


#|***************************************************RIGHT COLUMN FUNCTIONS****************************************************|#

;;Functions to Add Nodes
(define add_node_btn (new button%  [parent right-column] [label "ADD NODE"]  [callback (lambda (button event) (addNodetoGraph))]))
(define (addNodetoGraph)
  (drawNodes (string->number(send x-field get-value)) (string->number(send y-field get-value)))
  )
(define (addPostoHash x y)
  ((hash-set! xypos-hash (+ 'x counter) (+ 'y counter))
   (set! counter (+ counter 1))))

;;Functions to Find Paths
(define search_routes_btn (new button%  [parent right-column] [label "SEARCH"]  [callback (lambda (button event) (searchRoutes))]))
(define (searchRoutes)
  (display (find-paths (string->number (send src-field get-value)) (string->number (send dest-field get-value)) graph))
  (find-paths (string->number (send src-field get-value)) (string->number (send dest-field get-value)) graph)
)

;;Functions to join Nodes
(define (joinNodes_btn)(new button%  [parent right-column] [label "SEARCH"]  [callback (lambda (button event) (joinNodes))]))
(define (joinNodes)
  (addToGraph (string->number (send name-field get-value)) (string->number (send  to-box get-value)))
  (display graph)
  )


#|**************************************************CENTER COLUMN FUNCTIONS****************************************************|#

;;Map Display
(define map-canvas (new canvas% [parent center-column]))
(define dc (send map-canvas get-dc))

;;Draw nodes given an x and y
(define (drawNodes x y)
  (send dc set-brush "black" 'solid)
  (send dc draw-ellipse x y 10 10)
)

;;Draw routes between two nodes
(define (drawRoutes x1 y1 x2 y2)
  (send dc set-brush "black" 'solid)
  (send dc draw-line x1 y1 x2 y2)
  )




#|******************************************************INTERFACE RUNNER*******************************************************|#

;;Window handling from main file
(define (runner bool)
  (cond ((equal? bool #t)
         (send window show #t)
         ;(load-map)
         )
        (else
         (send window show #f))))

(send window show #t)