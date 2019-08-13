#lang racket

(provide get-neighbors)

;Neighbors
(define (get-neighbors node graph)
  (cond ((null? graph) '()) ; did not find node in the graph.
        ((equal? node (caar graph)) (cadar graph))
        (else (get-neighbors node (cdr graph)))))



