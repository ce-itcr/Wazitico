#lang racket/gui

(require racket/draw)
(provide colorable-button%)

(define text-size-dc
  (new bitmap-dc% [bitmap (make-object bitmap% 1 1)]))

(define colorable-button%
  (class button%
    (init [(internal-label label)]
          [(initial-color color) "black"]
          [(internal-font font) normal-control-font])
    (define label internal-label)
    (define font internal-font)
    (super-new [label (make-label label font initial-color)]
               [font font])
    (define/override (set-label l)
      (set! label l)
      (super set-label l))
    (define/private (make-label label font color)
      (cond
        [(string? label)
         (match-define-values (w h _ _)
           (send text-size-dc get-text-extent label font))
         (define new-label (make-object bitmap% (exact-ceiling w) (exact-ceiling h)))
         (define dc (new bitmap-dc% [bitmap new-label]))
         (send dc set-font font)
         (send dc set-text-foreground color)
         (send dc draw-text label 0 0)
         new-label]
        [else label]))
    (define/public (set-color c)
      (define new-label (make-label label font c))
      (super set-label new-label))))