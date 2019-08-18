#lang racket

(require "../util/basic_operations.rkt")
(provide find-paths addToGraph graph)

(define graph '())

;Receives two nodes and adds them to the graph as a connection with the format (first (second)).
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
  (cond((member-list? to localList)
        '(-1))
       (else
        (list index))
       )
  )

;Find all routes between src and dest in a graph
;Function uses width first
(define (find-paths src dest graph)
  (cond ((equal? src dest)
         (list src))
        (else
         (find-paths-aux (list (list src)) dest graph '()))))

(define (find-paths-aux paths end graph result)
  (cond ((null? paths)
         (reverse-sublists result))
        ((equal? end (caar paths))
         (find-paths-aux (cdr paths)
                         end
                         graph
                         (cons (car paths) result)))
        (else
         (find-paths-aux (append (extend (car paths) graph)
                                 (cdr paths))
                         end
                         graph
                         result)
         )))


