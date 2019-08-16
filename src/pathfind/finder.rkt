#lang racket

(require "../util/basic_operations.rkt")
(provide find-paths)

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



