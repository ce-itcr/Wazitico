#|----------------------------------------------------------------------------------------------------------------

  @file main.rkt
  @version 0.1
  @date
  @authors angelortizv, isolis2000, jesquivel48
  @brief Wazitico corresponds to Project I for the course of Languages, Compilers and Interpreters. (CE3104),
         Languages module. It aims to develop a mixed graph that simulates the famous Waze application.

----------------------------------------------------------------------------------------------------------------|#

#lang racket

(require "app/interface.rkt"
         "test/pathfind/finder_tests.rkt"
         "test/interface/interface_tests.rkt"
         )

(module+ test
  ;;Tests to be run
  (display "------- WAZITICO : APPLICATION TESTS -------\n\n")
  (run_finder_test)
  (run_interface_test)
  (display "\n------- WAZITICO : APPLICATION TESTS -------\n")
  )

(module+ main
  ;;Main entry point, executed when run with the `racket executable`.
  (runner #t)
  )
