#lang racket

(require "../../src/pathfind/finder.rkt")
(provide run_finder_test)

(define tester_graph '((a (b f)) (b (a c)) (c (b d h)) (d (c e)) (e (d j)) (f (a g k))
                          (g (b h)) (h (i m)) (i (d j)) (j (e o)) (k (f p)) (l (g k))
                          (m (h l r)) (n (m i)) (o (j n t)) (p (q u)) (q (l r)) (r (s w))
                          (s (n t)) (t (o y)) (u (p v)) (v (u q w)) (w (v x)) (x (w s y))
                          (y (t x))))

(define (run_neighbours)
  (cond((and
         (equal? (neighbours 'a tester_graph) '(b f))
         (equal? (neighbours 'a tester_graph) '(b f))
         (equal? (neighbours 'a tester_graph) '(b f))
         (equal? (neighbours 'a tester_graph) '(b f))
         )(display "[OK] Neighbours tests passed successfully \n"))
      (else (display "[ERROR] Neighbours \n"))
      )
  )

(define (run_findpath)
  (cond((and
         (equal? (findPath 'a 'b neighbours tester_graph) '(a b))
         )(display "[OK] FindPath tests passed successfully \n"))
      (else (display "[ERROR] FindPath \n"))
      )
  )

(define (run_finder_test)
  (display "GRAPH TESTS-------------------------------- \n")
  (cond ((and
          (run_neighbours)
          (run_findpath))))
  (display "GRAPH TESTS-------------------------------- \n"))

