#lang racket

(require "../util/basic_operations.rkt")
(provide findPaths addToGraph graph)

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

;;
(define (shortest-path node-id1 node-id2 graph)
  (define (insert connection current-cost cur-path lst)
    (cond [(null? lst) (list (cons
                              (cons (idPointsTo connection)
                                   (+ current-cost (cost connection)))
                              (append cur-path (list (idPointsTo connection)))))]
          [(< (+ (cost connection) current-cost) (cadar lst))
           (cons (cons
                  (cons (idPointsTo connection)
                       (+ current-cost (cost connection)))
                  (append cur-path (list (idPointsTo connection))))
                 lst)]
          [else (cons (car lst) (insert connection current-cost cur-path (cdr lst)))]
      ))
  (define (add-connections-to-list connections cur-path cur-cost lst)
    (cond [(null? connections) lst]
          [else (add-connections-to-list (cdr connections) cur-path cur-cost
                 (insert (car connections) cur-cost cur-path lst))]
      ))
  (define (iter lst)
    (cond [(eq? (caaar lst) node-id2) (list (cdaar lst) (cdar lst))]
          [else (iter (add-connections-to-list
                       (connections (associate (caaar lst) graph))
                       (cdar lst)
                       (cdaar lst)
                       (cdr lst))
                     )]
      ))
  (iter (list (cons
               (cons
                node-id1
                0
                )
               (list node-id1)))))
