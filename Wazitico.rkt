#lang racket/gui
(require racket/gui/base)

(define graph '((a ()) (b (a c)) (c ()) (d (c e)) (e ()) (f (a g k)) (g ()) (h (i m)) (i ()) (j (e o)) (k ()) (l (g k)) (m ()) (n (m i)) (o ()) (p (q u)) (q ()) (r (s w)) (s ()) (t (o y)) (u ()) (v (u q w)) (w ()) (x (w s y)) (y ())))
