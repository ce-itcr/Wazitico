#lang racket

(provide neighbours
         findPath-depth)

;There is route
(define (solution? end route)
  (equal? end (car route)))

;Neighbors
(define (neighbours ele graph)
  (let ((result (assoc ele graph)))
    (cond ((equal? result #f)
           #f)
          (else
           (cadr result)))))

;Find routes by depth first
(define (member? ele list1)
  (cond((null? list1)
        #f)
       ((equal? ele (car list1))
        #t)
       (else
        (member? ele (cdr list1)))))

(define (extend route graph)
  (apply append(map(lambda(x)
                     (cond ((member? x route) '())
                           (else (list (cons x route)))))
                   (neighbours (car route) graph))))

(define (findPath-depth start end graph)
  (depth-aux (list (list start)) end graph))

(define (depth-aux routes end graph)
  (cond ((null? routes)
         '())
        ((solution? end (car routes))
         (reverse (car routes)))
        (else
         (depth-aux (append (extend (car routes) graph)
                            (cdr routes))
                    end
                    graph))))
