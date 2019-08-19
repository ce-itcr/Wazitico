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
(define lineHash (make-hash))

;;Windows and Interface Panels
(define window (new frame% [label "Wazitico"] [width 1200] [height 700] [style '(no-resize-border)]))
(define row (new horizontal-panel% [parent window] [style '(border)] [alignment '(center center)]))

(define left-column (new vertical-panel% [parent row][alignment '(center center)]
                                         [style '(border)][horiz-margin 10][vert-margin 10][min-width 300]))
(define center-column (new vertical-panel% [parent row][alignment '(center center)]
                                           [style '(border)][vert-margin 10][horiz-margin 10][min-width 500]))
(define upper-center-column (new horizontal-panel% [parent center-column][alignment '(center center)]
                                                   [horiz-margin 10][min-height 50]))
(define right-column (new vertical-panel% [parent row][alignment '(center center)]
                                          [style '(border)][horiz-margin 10][vert-margin 10][min-width 300]))

;;Map Display
(define map-canvas (new canvas% [parent center-column] [min-height 700]))
(define dc (send map-canvas get-dc))

;;Image Buttons
(define btn_addnode (make-object bitmap%   "img/btn_addnode.png" 'png/alpha #f #f 6.0))
(define btn_findpaths (make-object bitmap% "img/btn_findpaths.png" 'png/alpha #f #f 6.0))
(define btn_joinnodes (make-object bitmap% "img/btn_joinnodes.png" 'png/alpha #f #f 6.0))
(define btn_selectroute (make-object bitmap% "img/btn_selectroute.png" 'png/alpha #f #f 6.0))



#|**************************************************LEFT COLUMN DEFINITIONS****************************************************|#

;;App Icon
(define app_icon (make-object bitmap% "img/ic_launcher.png" 'png/alpha))
(void (new message% [parent left-column] [label app_icon]))

;;Interaction spaces in left panel : Add Nodes
(define name-field
  (new text-field% [parent left-column] [label "Name:"] [font (make-object font% 10 'default 'normal)]))
(define x-field
  (new text-field% [parent left-column] [label "X Pos:"] [font (make-object font% 10 'default 'normal )]))
(define y-field
  (new text-field% [parent left-column] [label "Y Pos:"] [font (make-object font% 10 'default 'normal )]))

(define add_node_btn (new button%  [parent left-column] [label btn_addnode] [font (make-object font% 10 'default 'normal 'bold)]
                                   [callback (lambda (button event) (addNodetoGraph))]))

;;Interaction spaces in left panel : Join Nodes
(define from-field
  (new text-field% [parent left-column] [label "  From:"] [font (make-object font% 10 'default 'normal )]))
(define to-field
  (new text-field% [parent left-column] [label "      To:"] [font (make-object font% 10 'default 'normal )]))
(define weight-field
  (new text-field% [parent left-column] [label "Weight:"] [font (make-object font% 10 'default 'normal )]))

(define joinNodes_btn(new button%  [parent left-column] [label btn_joinnodes] [font (make-object font% 10 'default 'normal 'bold)]
                                   [callback (lambda (button event) (joinNodes)(drawWeight (send weight-field get-value)))]))


#|***************************************************LEFT COLUMN FUNCTIONS*****************************************************|#

;;Functions to Add Nodes
(define (addNodetoGraph)
  (drawNodes (string->number(send x-field get-value)) (string->number(send y-field get-value)) (send name-field get-value))
  (addPostoHash (send name-field get-value) (list (+ (string->number(send x-field get-value)) 5)
                                                  (+ (string->number(send y-field get-value)) 5)))
  )

;;Add node position to hash
(define (addPostoHash key coordlist)
  (hash-set! nameNumberHash key counter)
  (hash-set! numberNameHash counter key)
  (hash-set! xypos-hash counter coordlist)
  (set! counter (+ counter 1))
  )

;;Join Nodes
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

(define (drawWeight weight)
   (send dc draw-text weight (+ (car(hash-ref xypos-hash (hash-ref nameNumberHash (send from-field get-value)))) 10)
                             (+ (cadr(hash-ref xypos-hash (hash-ref nameNumberHash (send from-field get-value)))) 10)))



#|*************************************************CENTER COLUMN DEFINITIONS***************************************************|#

;;Interaction spaces in center panel : Find Paths
(define src-field
  (new text-field% [parent upper-center-column] [label "Src"]  [font (make-object font% 10 'default 'normal)]))
(define dest-field
  (new text-field% [parent upper-center-column] [label "Dest"]  [font (make-object font% 10 'default 'normal )]))


#|**************************************************CENTER COLUMN FUNCTIONS****************************************************|#

;;Functions to Find Paths
(define search_routes_btn (new button%  [parent upper-center-column] [label btn_findpaths]
                                        [font (make-object font% 10 'default 'normal 'bold)]
                                        [callback (lambda (button event) (searchRoutes))]))
(define (searchRoutes)
  (send all-paths-list clear)
  (serchRoutesAux (find-paths (hash-ref nameNumberHash (send src-field get-value))
                              (hash-ref nameNumberHash (send dest-field get-value))
                              graph) 0)
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


#|**************************************************RIGHT COLUMN DEFINITIONS***************************************************|#

;;List box with all paths
(define all-paths-list
  (new list-box% [parent right-column] [label ""] [font (make-object font% 10 'default 'normal )]
                 [choices '()]
                 [style (list 'single 'column-headers 'variable-columns)]
                 [columns (list "Paths")]))


(define selectRoute_btn (new button%  [parent right-column] [label btn_selectroute]
                                      [font (make-object font% 10 'default 'normal 'bold)]
                                      [callback (lambda (button event)
                                                        (getSelectedPath (send all-paths-list get-string-selection)))]))


#|***************************************************RIGHT COLUMN FUNCTIONS****************************************************|#

;;Select Route from list-box
(define (getSelectedPath path)
  (display path)
  (send dc set-pen "red" 3 'solid)
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