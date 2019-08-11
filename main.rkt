#|----------------------------------------------------------------------------------------------------------------

  @file main.rkt
  @version 0.1
  @date
  @authors angelortizv, isolis2000, jesquivel48
  @brief Wazitico corresponds to Project I for the course of Languages, Compilers and Interpreters. (CE3104),
         Languages module. It aims to develop a mixed graph that simulates the famous Waze application.

----------------------------------------------------------------------------------------------------------------|#

#lang racket

(require
;         "app/interface.rkt")
  "src/pathfind/finder.rkt"
  "test/pathfind/finder_tests.rkt")

(module+ test
  ;;Tests to be run
  (run_finder_test)
  )

(module+ main
  ;;Main entry point, executed when run with the `racket executable`.
  )
