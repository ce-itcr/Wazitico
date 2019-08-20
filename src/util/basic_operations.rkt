#lang racket

(provide (all-defined-out))

#|*********************************************************LIST OPERATIONS*********************************************************|#

;Length of a list
(define (length list1)
  (cond ((null? list1)
         0)
        (else
         (+ 1 (length (cdr list1))))))

;List Member
(define (memberList? ele list1)
  (cond((null? list1)
        #f)
       ((equal? ele (car list1))
        #t)
       (else
        (memberList? ele (cdr list1)))))

;Extract the nth element
(define (extractElement index list1)
  (cond ((null? list1)
         #f)
        ((equal? index 1)
         (car list1))
        (else
         (extractElement (- index 1)(cdr list1)))))

;Remove an item from a list
(define (removeElement ele list1)
  (cond((null? list1)
        '())
       ((equal? ele (car list1))
        (cdr list1))
       (else
        (cons (car list1)
              (removeElement ele (cdr list1))))))

;Extract the last item
(define (lastElement list1)
  (cond((null? list1)
        #f)
       ((null? (cdr list1))
        (car list1))
       (else
        (lastElement (cdr list1)))))

;Invert a list
(define (reverseList list1)
  (cond ((null? list1)
         '())
        (else
         (append (reverseList (cdr list1))
                 (list (car list1))))))

;Reverse sublists
(define (reverseSublists list1)
  (reverseSublistsAux list1 '()))

(define (reverseSublistsAux list1 result)
  (cond ((null? list1)
         (reverse result))
        (else
         (reverseSublistsAux (cdr list1)
                               (cons (reverse (car list1))
                                     result)))))


#|********************************************************GRAPH OPERATIONS*********************************************************|#

(define (firstNode graph) (car graph))
(define (exceptFirst graph) (cdr graph))
(define (isEmpty? graph) (null? graph))

;There is route
(define (solution? end route)
  (equal? end (car route)))

;Neighbors
(define (getNeighbors node graph)
  (cond ((null? graph) '()) ; did not find node in the graph.
        ((equal? node (caar graph)) (cadar graph))
        (else (getNeighbors node (cdr graph)))))

;Function that creates new paths
(define (extend path graph)
  (extendAux (getNeighbors (car path) graph) '() path))

(define (extendAux neighbors result path)
  (cond ((null? neighbors)
         result)
        ((memberList? (car neighbors) path) (extendAux (cdr neighbors) result path))
        (else
         (extendAux (cdr neighbors)
                     (append result (list (list* (car neighbors) path)))
                     path))))