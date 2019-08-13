#lang racket

(require "../../src/pathfind/finder.rkt")
(provide run_finder_test)

(define tester_graph '((a (b f)) (b (a c)) (c (b d h)) (d (c e)) (e (d j)) (f (a g k))
                          (g (b h)) (h (i m)) (i (d j)) (j (e o)) (k (f p)) (l (g k))
                          (m (h l r)) (n (m i)) (o (j t n)) (p (q u)) (q (l r)) (r (s w))
                          (s (n t)) (t (o y)) (u (p v)) (v (u q w)) (w (v x)) (x (w s y))
                          (y (t x))))

(define (run_neighbours)
  (cond((and
         (equal? (get-neighbors 'a tester_graph) '(b f))
         (equal? (get-neighbors 'g tester_graph) '(b h))
         (equal? (get-neighbors 'm tester_graph) '(h l r))
         (equal? (get-neighbors 's tester_graph) '(n t))
         )(display "[OK] Neighbours tests passed successfully \n"))
      (else (display "[ERROR] Neighbours \n"))
      )
  )

(define (run_findpath)
  (cond((and
         ;(equal? (findPath-depth 'a 'c tester_graph) '(a b c))
         ;(equal? (findPath-depth 'g 'd tester_graph) '(g b a f k p q r s n m h i d))
         )(display "[OK] FindPath tests passed successfully \n"))
      (else (display "[ERROR] FindPath \n"))
      )
  )

(define (run_finder_test)
  (display "GRAPH TESTS-------------------------------- \n")
  (cond ((and)))
          (run_neighbours)
          ;(run_findpath))))
  (display "GRAPH TESTS-------------------------------- \n"))


;(findPath-depth 'a 'y tester_graph)
;(get-neighbors 'm tester_graph)
