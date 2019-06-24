#lang rosette
(provide (all-defined-out))

(require "model.rkt")

;; For our interpreter, we write Rosette implementations of all supported
;; RxJS operators that we want to use for synthesis

;; Each operator takes one or more streams as arguments and returns a stream

;; Note that some operators have the same names as Racket methods,
;; so we always add the prefix rx

;; http://reactivex.io/documentation/operators/map.html
(define (rxMap f inputStream)
  (for/list ([elt inputStream])
    (if (not-empty-event? elt)
        (f elt)
        NOEVENT)))

;; http://reactivex.io/documentation/operators/merge.html
(define (rxMerge stream1 stream2)
  (for/list ([elt1 stream1]
             [elt2 stream2])
    (if (not-empty-event? elt1) elt1 elt2)))

;; http://reactivex.io/documentation/operators/scan.html
(define (rxScan f inputStream)
  (for/list ([idx (range (length inputStream))])
    (let ([evts (filter not-empty-event? (take inputStream (add1 idx)))])
      (if (empty-event? (list-ref inputStream idx))
          NOEVENT
          (if (equal? 1 (length evts))
              (list-ref inputStream idx)
              (foldl f (first evts) (cdr evts)))))))