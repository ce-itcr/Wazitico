#lang racket

(require "../util/basic_operations.rkt")
(provide findPaths addToGraph graph shortestPath)

(define graph '())

;Receives two nodes and adds them to the graph as a connection with the format (first (second)).
;If either the first node or both are already in the graph, the function adds what's needed only.
(define (addToGraph first second)
  (cond ((null? (axisExists first second graph 0))
         (set! graph
               (cons (cons first (list (list second))) graph)))
        ((not (= (car (axisExists first second graph 0)) -1))
         (addByIndex (car (axisExists first second graph 0)) second (list-ref graph (car (axisExists first second graph 0)))))))

(define (addByIndex index numToAdd oldNode)
  (set! graph
        (cons (append (list (list-ref oldNode 0)) (list(cons numToAdd (list-ref oldNode 1)))) (remove (list-ref graph index) graph))))

;Check if the axis exists in the graph
(define (axisExists from to localGraph index)
  (cond ((empty? localGraph)
         '())
        ((eq? (caar localGraph) from)
         (axisExistsTo to (cadar localGraph) index))
        (else
         (axisExists from to (cdr localGraph) (+ index 1)))
       )
  )

(define (axisExistsTo to localList index)
  (cond((memberList? to localList)
        '(-1))
       (else
        (list index))
       )
  )

;Find all routes between two nodes in a graph
;Function uses width first algorithm
(define (findPaths src dest graph)
  (cond ((equal? src dest)
         (list src))
        (else
         (findPathsAux (list (list src)) dest graph '()))))

(define (findPathsAux paths end graph result)
  (cond ((null? paths)
         (reverseSublists result))
        ((equal? end (caar paths))
         (findPathsAux (cdr paths)
                         end
                         graph
                         (cons (car paths) result)))
        (else
         (findPathsAux (append (extend (car paths) graph)
                                 (cdr paths))
                         end
                         graph
                         result)
         )))

;;Find shortest route between two nodes in a graph
(define (shortestPath src dest graph)
  (define (insert connection currentCost currentPath list1)
    (cond [(null? list1) (list (cons
                              (cons (idPointsTo connection)
                                   (+ currentCost (cost connection)))
                              (append currentPath (list (idPointsTo connection)))))]
          [(< (+ (cost connection) currentCost) (cadar list1))
           (cons (cons
                  (cons (idPointsTo connection)
                       (+ currentCost (cost connection)))
                  (append currentPath (list (idPointsTo connection))))
                 list1)]
          [else (cons (car list1) (insert connection currentCost currentPath (cdr list1)))]
      ))
  (define (addConnectionsToList connections currentPath currentCost list1)
    (cond [(null? connections) list1]
          [else (addConnectionsToList (cdr connections) currentPath currentCost
                 (insert (car connections) currentCost currentPath list1))]
      ))
  (define (iter list1)
    (cond [(eq? (caaar list1) dest) (list (cdaar list1) (cdar list1))]
          [else (iter (addConnectionsToList
                       (connections (associate (caaar list1) graph))
                       (cdar list1)
                       (cdaar list1)
                       (cdr list1))
                     )]
      ))
  (iter (list (cons
               (cons
                src
                0
                )
               (list src)))))
