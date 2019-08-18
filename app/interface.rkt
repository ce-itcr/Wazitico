#lang racket/gui

(require racket/draw simple-svg)
(require "../src/pathfind/finder.rkt"
         "util/gui_functions.rkt")
(provide runner)


#|****************************************************GLOBAL UI DEFINITIONS****************************************************|#

;;Colors
(define black (make-object color% "black"))
(define white (make-object color% "white"))
(define red (make-object color% "red"))
(define gray (make-object color% "gray"))

;;Pens and their colors
(define red-drawing-pen (make-object pen% red 4 'solid))
(define gray-drawing-pen (make-object pen% gray 4 'solid))
(define red-brush (instantiate brush% ("RED" 'solid)))
(define  gray-brush (instantiate brush% ("GRAY" 'solid)))

;;Interface Variable Definition
(define xypos-hash (make-hash))
(define nameNumberHash (make-hash))
(define numberNameHash (make-hash))
(define counter 0)
(define lineList '())

;;Windows and Interface Panels
(define window (new frame% [label "Wazitico"] [width 1200] [height 700] [style '(no-resize-border)]))
(define row (new horizontal-panel% [parent window] [style '(border)] [alignment '(center center)]))
(define left-column (new vertical-panel% [parent row] [style '(border)] [alignment '(center center)] [min-width 300]))
(define center-column (new vertical-panel% [parent row] [style '(border)] [alignment '(center center)] [min-width 600]))
(define right-column (new vertical-panel% [parent row] [style '(border)][alignment '(center center)] [min-width 300]))


#|**************************************************RIGHT COLUMN DEFINITIONS***************************************************|#

;;Interaction spaces in right panel : Add Nodes
(define name-field
  (new text-field% [parent right-column] [label "Name:"] [font (make-object font% 10 'default 'normal)]))
(define x-field
  (new text-field% [parent right-column] [label "X Pos:"] [font (make-object font% 10 'default 'normal )]))
(define y-field
  (new text-field% [parent right-column] [label "Y Pos:"] [font (make-object font% 10 'default 'normal )]))

(define add_node_btn (new button%  [parent right-column] [label "ADD NODE"] [font (make-object font% 10 'default 'normal 'bold)]
                                   [callback (lambda (button event) (addNodetoGraph))]))

;;Interaction spaces in right panel : Join Nodes
(define from-field
  (new text-field% [parent right-column] [label "From"] [font (make-object font% 10 'default 'normal )]))
(define to-field
  (new text-field% [parent right-column] [label "To"] [font (make-object font% 10 'default 'normal )]))

(define joinNodes_btn(new colorable-button%  [parent right-column] [label "JOIN NODES"] [font (make-object font% 10 'default 'normal 'bold)]
                                   [callback (lambda (button event) (joinNodes))] ))

(send joinNodes_btn set-color (make-object color% 188 220 252))

;;List box with all paths
(define all-paths-list
  (new list-box% [parent right-column] [label "Paths"] [font (make-object font% 10 'default 'normal )]
                 [choices '()]
                 [style (list 'single 'column-headers 'variable-columns)]
                 [columns (list "Path")]))

(define selectRoute_btn (new button%  [parent right-column] [label "SELECT ROUTE"] [font (make-object font% 10 'default 'normal 'bold)]
                                      [callback (lambda (button event) (getSelectedPath))]))


#|***************************************************RIGHT COLUMN FUNCTIONS****************************************************|#

;;Functions to Add Nodes
(define (addNodetoGraph)
  (drawNodes (string->number(send x-field get-value)) (string->number(send y-field get-value)) (send name-field get-value))
  (addPostoHash (send name-field get-value) (list (+ (string->number(send x-field get-value)) 5)
                                                  (+ (string->number(send y-field get-value)) 5)))
  )
(define (addPostoHash key coordlist)
  (hash-set! nameNumberHash key counter)
  (hash-set! numberNameHash counter key)
  (hash-set! xypos-hash counter coordlist)
  (set! counter (+ counter 1))
   )

;;Functions to join Nodes
(define (joinNodes)
  (addToGraph (hash-ref nameNumberHash (send from-field get-value)) (hash-ref nameNumberHash (send  to-field get-value)))
  (set lineList (cons (list (hash-ref nameNumberHash (send from-field get-value))
                            (hash-ref nameNumberHash (send  to-field get-value)))
                      lineList))
  (send dc draw-line (car(hash-ref xypos-hash (hash-ref nameNumberHash (send from-field get-value))))
                     (cadr(hash-ref xypos-hash (hash-ref nameNumberHash (send from-field get-value))))
                     (car(hash-ref xypos-hash (hash-ref nameNumberHash (send to-field get-value))))
                     (cadr(hash-ref xypos-hash (hash-ref nameNumberHash (send to-field get-value)))))
  (display graph)
  )

;;Select Route from list-box
(define (getSelectedPath path)
  (getSelectedPathAux (send all-paths-list get-data (send all-paths-list get-selections)) lineList)
  )

(define (getSelectedPathAux pathlist linesList)
  (send dc set-pen "red" 3 'solid)
  )

#|*************************************************CENTER COLUMN DEFINITIONS***************************************************|#

;;Interaction spaces in right panel : Find Paths
(define src-field
  (new text-field% [parent center-column] [label "Src"]  [font (make-object font% 10 'default 'normal)]))
(define dest-field
  (new text-field% [parent center-column] [label "Dest"]  [font (make-object font% 10 'default 'normal )]))


#|**************************************************CENTER COLUMN FUNCTIONS****************************************************|#

;;Functions to Find Paths
(define search_routes_btn (new button%  [parent center-column] [label "SEARCH"] [font (make-object font% 10 'default 'normal 'bold)]
                                        [callback (lambda (button event) (searchdrawLinRoutes))]))
(define (searchRoutes)
  (send all-paths-list clear)
  (serchRoutesAux (find-paths (hash-ref nameNumberHash (send src-field get-value)) (hash-ref nameNumberHash (send dest-field get-value)) graph) 0)
)

(define (serchRoutesAux routesList routesCounter)
  (cond ((null? routesList)
         #t)
        (else
         (send all-paths-list append (~a (for/list ([i (car routesList)])
                                           (hash-ref numberNameHash i))))
         (serchRoutesAux (cdr routesList) (+ routesCounter 1)))
        )
  )

;;Map Display
(define map-canvas (new canvas% [parent center-column]))
(define dc (send map-canvas get-dc))

;;Draw nodes given an x and y
(define (drawNodes x y name)
  (send dc set-brush "black" 'solid)
  (send dc draw-ellipse x y 10 10)
  (send dc set-text-foreground "black")
  (send dc draw-text name (- x 10) (- y 20))
)

;;Draw routes between two nodes
(define (drawRoutes x1 y1 x2 y2)
  (send dc set-brush "black" 'solid)
  (send dc draw-line x1 y1 x2 y2)
  )

#|**************************************************LEFT COLUMN DEFINITIONS****************************************************|#

(define app_icon (make-object bitmap% "img/ic_launcher.png"))
;(define (draw-app_icon left-column dc) (send dc set-scale 0.4 0.4))
;(send dc draw-bitmap app_icon 10 10)
(void (new message% [parent left-column] [label app_icon]))

(define info_btn (new button%  [parent left-column] [label "INFO"]  [font (make-object font% 10 'default 'normal 'bold)]
                               [callback (lambda (button event) (addNodetoGraph))]))
(define exit_btn (new button%  [parent left-column] [label "EXIT"]  [font (make-object font% 10 'default 'normal 'bold)]
                               [callback (lambda (button event) (addNodetoGraph))]))

#|***************************************************LEFT COLUMN FUNCTIONS*****************************************************|#


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