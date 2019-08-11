#lang racket

(provide neighbours
         findPath)

; Node, Graph => Neighbours
(define (neighbours node graph)
  (local
    ; [List-of Node Neighbours] => Boolean
    ((define (isNode? x)
       (symbol=? (first x) node))
     (define nodeAndNeighbours
       (first (filter isNode? graph))))
    (second nodeAndNeighbours)))

; Node, Node, [Node, Graph => Neighbours], Graph => [Maybe Path]
(define (findPath s t neighbours graph)
  (cond
    ((symbol=? s t) (list t))
    (else
     (local
       ; Neighbours => [Maybe Path]
       ((define (findPathFrom n)
          (cond
            ((empty? n) #false)
            (else
             (local
               ((define path (findPath (first n) t neighbours graph)))
               (if (cons? path)
                   (cons s path)
                   (findPathFrom (rest n))))))))
       (findPathFrom (neighbours s graph))))))
          
