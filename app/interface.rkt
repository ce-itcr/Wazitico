#lang racket/gui

(require racket/draw racket/draw/arrow simple-svg pict)
(require "../src/pathfind/finder.rkt")
(provide runner)


#|****************************************************GLOBAL UI DEFINITIONS****************************************************|#

;;Colors
(define black (make-object color% "Black"))
(define white (make-object color% "White"))
(define red (make-object color% "Red"))
(define gray (make-object color% "Gray"))

;;Pens and their colors
(define redDrawingPen (make-object pen% red 4 'solid))
(define grayDrawingPen (make-object pen% gray 4 'solid))
(define blackDrawingPen (new pen% [color "black"][width 2]))
(define greenDrawingPen (new pen% [color (make-object color% 0 200 0)][width 2]))
(define redBrush (instantiate brush% ("RED" 'solid)))
(define grayBrush (instantiate brush% ("GRAY" 'solid)))
(define greenBrush (new brush% [color (make-object color% 40 70 50)]))

;;Interface Variable Definition
(define xyposHash (make-hash))
(define nameNumberHash (make-hash))
(define numberNameHash (make-hash))
(define counter 0)
(define lineList '())

;;Windows and Interface Panels
(define window (new frame% [label "Wazitico"] [width 1200] [height 700] [style '(no-resize-border)]))
(define row (new horizontal-panel% [parent window] [style '(border)] [alignment '(center center)]))

(define leftColumn (new vertical-panel% [parent row][alignment '(center center)]
                                         [style '(border)][horiz-margin 10][vert-margin 10][min-width 300]))
(define centerColumn (new vertical-panel% [parent row][alignment '(center center)]
                                           [style '(border)][vert-margin 10][horiz-margin 10][min-width 500]))
(define upperCenterColumn (new horizontal-panel% [parent centerColumn][alignment '(center center)]
                                                   [horiz-margin 10][min-height 50]))
(define rightColumn (new vertical-panel% [parent row][alignment '(center center)]
                                          [style '(border)][horiz-margin 10][vert-margin 10][min-width 300]))

;;Map Display
(define mapCanvas (new canvas% [parent centerColumn] [min-height 700]))
(define dc (send mapCanvas get-dc))

;;Image Buttons
(define img_addnode (make-object bitmap%   "img/btn_addnode.png" 'png/alpha #f #f 6.0))
(define img_findpaths (make-object bitmap% "img/btn_findpaths.png" 'png/alpha #f #f 6.0))
(define img_joinnodes (make-object bitmap% "img/btn_joinnodes.png" 'png/alpha #f #f 6.0))
(define img_selectroute (make-object bitmap% "img/btn_selectroute.png" 'png/alpha #f #f 6.0))

#|**************************************************LEFT COLUMN DEFINITIONS****************************************************|#

;;App Icon
(define img_appIcon (make-object bitmap% "img/ic_launcher.png" 'png/alpha))
(void (new message% [parent leftColumn] [label img_appIcon]))

;;Interaction spaces in left panel : Add Nodes
(define nameField
  (new text-field% [parent leftColumn] [label " Name:"] [font (make-object font% 10 'default 'normal)]))
(define xField
  (new text-field% [parent leftColumn] [label "X Pos:"] [font (make-object font% 10 'default 'normal )]))
(define yField
  (new text-field% [parent leftColumn] [label "Y Pos:"] [font (make-object font% 10 'default 'normal )]))
(define colorField
  (new text-field% [parent leftColumn] [label " Color:"] [font (make-object font% 10 'default 'normal )]))

(define btn_addNode (new button%  [parent leftColumn] [label img_addnode] [font (make-object font% 10 'default 'normal 'bold)]
                                   [callback (lambda (button event) (addNodetoGraph))]))

;;Interaction spaces in left panel : Join Nodes
(define fromField
  (new text-field% [parent leftColumn] [label "  From:"] [font (make-object font% 10 'default 'normal )]))
(define toField
  (new text-field% [parent leftColumn] [label "      To:"] [font (make-object font% 10 'default 'normal )]))
(define weightField
  (new text-field% [parent leftColumn] [label "Weight:"] [font (make-object font% 10 'default 'normal )]))

(define btn_joinNodes (new button%  [parent leftColumn] [label img_joinnodes] [font (make-object font% 10 'default 'normal 'bold)]
                                   [callback (lambda (button event) (joinNodes blackDrawingPen
                                                                               (car(hash-ref xyposHash (hash-ref nameNumberHash (send fromField get-value))))
                                                                               (cadr(hash-ref xyposHash (hash-ref nameNumberHash (send fromField get-value))))
                                                                               (car(hash-ref xyposHash (hash-ref nameNumberHash (send toField get-value))))
                                                                               (cadr(hash-ref xyposHash (hash-ref nameNumberHash (send toField get-value)))))
                                               (drawWeight (send weightField get-value)))]))

#|***************************************************LEFT COLUMN FUNCTIONS*****************************************************|#

;;Functions to Add Nodes
(define (addNodetoGraph)
  (drawNodes (string->number(send xField get-value)) (string->number(send yField get-value)) (send nameField get-value) (send colorField get-value))
  (addPostoHash (send nameField get-value) (list (+ (string->number(send xField get-value)) 5)
                                                  (+ (string->number(send yField get-value)) 5))))

;;Add node position to hash
(define (addPostoHash key coordlist)
  (hash-set! nameNumberHash key counter)
  (hash-set! numberNameHash counter key)
  (hash-set! xyposHash counter coordlist)
  (set! counter (+ counter 1)))

;;Join Nodes
(define (joinNodes color x1 y1 x2 y2)
  (addToGraph (hash-ref nameNumberHash (send fromField get-value)) (hash-ref nameNumberHash (send  toField get-value)))
  (set! lineList (cons (list (hash-ref nameNumberHash (send fromField get-value))
                            (hash-ref nameNumberHash (send  toField get-value)))
                      lineList))
  (send dc set-pen color)
  (draw-arrow dc x1 y1 x2 y2 0 0)
  (display graph))

;;Draw Routes Weight
(define (drawWeight weight)
   (send dc draw-text weight (+ (car(hash-ref xyposHash (hash-ref nameNumberHash (send fromField get-value)))) 10)
                             (+ (cadr(hash-ref xyposHash (hash-ref nameNumberHash (send fromField get-value)))) 10)))



#|*************************************************CENTER COLUMN DEFINITIONS***************************************************|#

;;Interaction spaces in center panel : Find Paths
(define srcField
  (new text-field% [parent upperCenterColumn] [label "Src"]  [font (make-object font% 10 'default 'normal)]))
(define destField
  (new text-field% [parent upperCenterColumn] [label "Dest"]  [font (make-object font% 10 'default 'normal )]))


#|**************************************************CENTER COLUMN FUNCTIONS****************************************************|#

;;Functions to Find Paths
(define btn_searchRoutes (new button%  [parent upperCenterColumn] [label img_findpaths]
                                        [font (make-object font% 10 'default 'normal 'bold)]
                                        [callback (lambda (button event) (searchRoutes))]))
(define (searchRoutes)
  (send allPathsList clear)
  (serchRoutesAux (findPaths (hash-ref nameNumberHash (send srcField get-value))
                              (hash-ref nameNumberHash (send destField get-value))
                              graph) 0)
)

(define (serchRoutesAux routesList routesCounter)
  (cond ((null? routesList)
         #t)
        (else
         (send allPathsList append (~a (numberToNameList (car routesList))))
         (serchRoutesAux (cdr routesList) (+ routesCounter 1)))
        )
  )

(define (numberToNameList routesList)
  (cond((null? routesList)
        '())
       (else
        (cons (hash-ref numberNameHash(car routesList)) (numberToNameList (cdr routesList))))
       )
  )

;;Draw nodes given an x and y
(define (drawNodes x y name color)
  (cond((eq? color null)
        (send dc set-pen "black" 'solid)
        (send dc draw-ellipse x y 10 10))
       (else
         (send dc set-brush color 'solid)
         (send dc draw-ellipse x y 10 10)))
  (send dc set-text-foreground "black")
  (send dc draw-text name (- x 10) (- y 20))
)

;;Draw routes between two nodes
(define (drawRoutes x1 y1 x2 y2 color)
  (send dc set-brush color 'solid)
  (send dc draw-line x1 y1 x2 y2)
  )


#|**************************************************RIGHT COLUMN DEFINITIONS***************************************************|#

;;List box with all paths
(define allPathsList
  (new list-box% [parent rightColumn] [label ""] [font (make-object font% 10 'default 'normal )]
                 [choices '()]
                 [style (list 'single 'column-headers 'variable-columns)]
                 [columns (list "Paths")]))


(define btn_selectRoute (new button%  [parent rightColumn] [label img_selectroute]
                                      [font (make-object font% 10 'default 'normal 'bold)]
                                      [callback (lambda (button event)
                                                        (getSelectedPath (convertToList  (send allPathsList get-string-selection))))]))


#|***************************************************RIGHT COLUMN FUNCTIONS****************************************************|#


(define (convertToList str)
  (with-input-from-string str read))

;;Select Route from list-box
(define (getSelectedPath path)
   (unless (empty? path)
   (display (first path))
     

     (joinNodes redDrawingPen
                (car (hash-ref xyposHash (hash-ref nameNumberHash (~v (first path)))))
                (cadr (hash-ref xyposHash (hash-ref nameNumberHash (~v (first path)))))
                (car (hash-ref xyposHash (hash-ref nameNumberHash (~v (first path)))))
                (cadr (hash-ref xyposHash (hash-ref nameNumberHash (~v (first path)))))
                )

     (getSelectedPath (rest path)))
  
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