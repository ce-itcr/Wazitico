#lang racket

(provide member-list? extract-element remove-element last-element invert-list)
(provide first-node except-first isEmpty? get-neighbors)

#|*********************************************************LIST OPERATIONS*********************************************************|#

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
(define (invert-list list1)
  (cond ((null? list1)
         '())
        (else
         (append (invert-list (cdr list1))
                 (list (car list1))))))


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
