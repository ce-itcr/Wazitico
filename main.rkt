#lang racket/gui
(require racket/gui/base)

(define graph '((a (b f)) (b (a c)) (c (b d h)) (d (c e)) (e (d j)) (f (a g k)) (g (b h)) (h (i m)) (i (d j)) (j (e o)) (k (f p)) (l (g k)) (m (h l r)) (n (m i)) (o (j n t)) (p (q u)) (q (l r)) (r (s w)) (s (n t)) (t (o y)) (u (p v)) (v (u q w)) (w (v x)) (x (w s y)) (y (t x))))(define graph '((a ()) (b (a c)) (c ()) (d (c e)) (e ()) (f (a g k)) (g ()) (h (i m)) (i ()) (j (e o)) (k ()) (l (g k)) (m ()) (n (m i)) (o ()) (p (q u)) (q ()) (r (s w)) (s ()) (t (o y)) (u ()) (v (u q w)) (w ()) (x (w s y)) (y ())))
