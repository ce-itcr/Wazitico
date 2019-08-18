#lang racket

(provide length member-list? extract-element remove-element last-element reverse-list reverse-sublists)
(provide first-node except-first isEmpty? get-neighbors extend)

#|*********************************************************LIST OPERATIONS*********************************************************|#

;Length of a list
(define (length list1)
  (cond ((null? list1)
         0)
        (else
         (+ 1 ( length (cdr list1))))))

;List Member
(define (member-list? ele list1)
  (cond((null? list1)
        #f)
       ((equal? ele (car list1))
        #t)
       (else
        (member-list? ele (cdr list1)))))

;Extract the nth element
(define (extract-element index list1)
  (cond ((null? list1)
         #f)
        ((equal? index 1)
         (car list1))
        (else
         (extract-element (- index 1)(cdr list1)))))

;Remove an item from a list
(define (remove-element ele list1)
  (cond((null? list1)
        '())
       ((equal? ele (car list1))
        (cdr list1))
       (else
        (cons (car list1)
              (remove-element ele (cdr list1))))))

;Extract the last item
(define (last-element list1)
  (cond((null? list1)
        #f)
       ((null? (cdr list1))
        (car list1))
       (else
        (last-element (cdr list1)))))

;Invert a list
(define (reverse-list list1)
  (cond ((null? list1)
         '())
        (else
         (append (reverse-list (cdr list1))
                 (list (car list1))))))

;Reverse sublists
(define (reverse-sublists list1)
  (reverse-sublists-aux list1 '()))

(define (reverse-sublists-aux list1 result)
  (cond ((null? list1)
         (reverse result))
        (else
         (reverse-sublists-aux (cdr list1)
                               (cons (reverse (car list1))
                                     result)))))


#|********************************************************GRAPH OPERATIONS*********************************************************|#

(define (first-node graph) (car graph))
(define (except-first graph) (cdr graph))
(define (isEmpty? graph) (null? graph))

;There is route
(define (solution? end route)
  (equal? end (car route)))

;Neighbors
(define (get-neighbors node graph)
  (cond ((null? graph) '()) ; did not find node in the graph.
        ((equal? node (caar graph)) (cadar graph))
        (else (get-neighbors node (cdr graph)))))

;Function that creates new paths
(define (extend path graph)
  (extend-aux (get-neighbors (car path) graph) '() path))

(define (extend-aux neighbors result path)
  (cond ((null? neighbors)
         result)
        ((member-list? (car neighbors) path) (extend-aux (cdr neighbors) result path))
        (else
         (extend-aux (cdr neighbors)
                     (append result (list (list* (car neighbors) path)))
                     path))))