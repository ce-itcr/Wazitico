#lang racket

(require "../util/basic_operations.rkt")
(provide find-paths)

(define graph '())

(define (addToGraph first second)
  (cond ((not (axisExists first second graph))
         (set! graph
              (cons (cons first (list second)) graph)))))

(define (axisExists from to localGraph)
  (cond ((empty? localGraph)
         #f)
        ((and (eq? (caar localGraph) from) (eq? (cadar localGraph) to))
         #t)
        (else
         (axisExists from to (cdr localGraph)))
       )
  )

;Find all routes between src and dest in a graph
;;Function uses width first
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
                         result))))




