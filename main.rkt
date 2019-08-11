#|----------------------------------------------------------------------------------------------------------------

  @file main.rkt
  @version 0.1
  @date
  @authors angelortizv, isolis2000, jesquivel48
  @brief Wazitico corresponds to Project I for the course of Languages, Compilers and Interpreters. (CE3104),
         Languages module. It aims to develop a mixed graph that simulates the famous Waze application.

----------------------------------------------------------------------------------------------------------------|#

#lang racket

(require "src/pathfind/finder.rkt")
;         "app/interface.rkt")

(define main_graph '((a (b f)) (b (a c)) (c (b d h)) (d (c e)) (e (d j)) (f (a g k))
                          (g (b h)) (h (i m)) (i (d j)) (j (e o)) (k (f p)) (l (g k))
                          (m (h l r)) (n (m i)) (o (j n t)) (p (q u)) (q (l r)) (r (s w))
                          (s (n t)) (t (o y)) (u (p v)) (v (u q w)) (w (v x)) (x (w s y))
                          (y (t x))))

(module+ test
  ;;Tests to be run 
  )

(module+ main
  ;;Main entry point, executed when run with the `racket executable`.
  )
