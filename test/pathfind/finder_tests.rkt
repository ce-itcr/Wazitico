#lang racket

(require "../../src/pathfind/finder.rkt"
         "../../src/util/basic_operations.rkt")
(provide run_finderTest)

(define tester_graph '((a (b f)) (b (a c)) (c (b d h)) (d (c e)) (e (d j)) (f (a g k))))

(define (run_neighbours)
  (cond((and
         (equal? (getNeighbors 'a tester_graph) '(b f))
         (equal? (getNeighbors 'c tester_graph) '(b d h))
         )(display "[OK] Neighbours tests passed successfully \n"))
      (else (display "[ERROR] Neighbours \n"))
      )
  )

(define (run_findpath)
  (cond((and
         (equal? (car (findPaths 'a 'c tester_graph)) '(a b c))
         (equal? (car (findPaths 'a 'k tester_graph)) '(a f k))
         )(display "[OK] FindPath tests passed successfully \n"))
      (else (display "[ERROR] FindPath \n"))
      )
  )

(define (run_finderTest)
  (display "--GRAPH TESTS: \n")
  (cond ((and)))
          (run_neighbours)
          (run_findpath)
  )