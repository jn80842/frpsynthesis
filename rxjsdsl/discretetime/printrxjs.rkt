#lang racket

(require "operators.rkt")
(require "instruction.rkt")
(require "sketch.rkt")

(provide (all-defined-out))

(define (get-insn-from-sketch sk insn-idx)
  (list-ref (sketch-insns sk) (- insn-idx (sketch-input-count sk))))

(define (print-rxjs-program sk)
  (print-rxjs-insn sk (sketch-retval-idx sk)))

(define (print-rxjs-insn sk insn-idx)
  (if (< insn-idx (sketch-input-count sk))
      (format "input~a" insn-idx)
      ((lookup-operator-print (insn-op-idx (get-insn-from-sketch sk insn-idx))) sk insn-idx)))

;; preliminary

(define (print-rxjs-single-stream op-name arg-stream)
  (format "~a.~a()" arg-stream op-name))

(define (print-rxjs-two-streams op-name arg-stream1 arg-stream2)
  (format "~a.~a(~a)" arg-stream1 op-name arg-stream2))

(define (print-rxjs-ho-function op-name arg-stream func-str)
  (format "~a.~a(~a)" arg-stream op-name func-str))

(define (print-rxjs-const-arg op-name arg-stream const-str)
  (format "~a.~a(~a)" arg-stream op-name const-str))

(define (print-rxjs-combineLatest sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-two-streams "combineLatest" (print-rxjs-insn sk (insn-input-idx1 current-insn))
            (print-rxjs-insn sk (insn-input-idx2 current-insn)))))

(define (print-rxjs-distinct sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-single-stream "distinct" (print-rxjs-insn sk (insn-input-idx1 current-insn)))))

(define (print-rxjs-filter sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-ho-function "filter" (print-rxjs-insn sk (insn-input-idx1 current-insn))
                            (list-ref pred-functions-str (insn-argfunc-idx1 current-insn)))))

(define (print-rxjs-map sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-ho-function "map" (print-rxjs-insn sk (insn-input-idx1 current-insn))
                            (list-ref int-functions-str (insn-argfunc-idx1 current-insn)))))

(define (print-rxjs-merge sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-two-streams "merge" (print-rxjs-insn sk (insn-input-idx1 current-insn))
            (print-rxjs-insn sk (insn-input-idx2 current-insn)))))

(define (print-rxjs-pairwise sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-single-stream "pairwise" (print-rxjs-insn sk (insn-input-idx1 current-insn)))))

(define (print-rxjs-scan sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-ho-function "scan" (print-rxjs-insn sk (insn-input-idx1 current-insn))
                            (list-ref int-int-functions-str (insn-argfunc-idx1 current-insn)))))

(define (print-rxjs-skip sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-const-arg "skip" (print-rxjs-insn sk (insn-input-idx1 current-insn))
                          (insn-argfunc-idx1 current-insn))))

(define (print-rxjs-take sk insn-idx)
  (let ([current-insn (get-insn-from-sketch sk insn-idx)])
    (print-rxjs-const-arg "take" (print-rxjs-insn sk (insn-input-idx1 current-insn))
                          (insn-argfunc-idx1 current-insn))))

(define (lookup-operator-print operator-idx)
  (list-ref (list print-rxjs-combineLatest
                  print-rxjs-distinct
                  print-rxjs-filter
                  print-rxjs-map
                  print-rxjs-merge
                  print-rxjs-pairwise
                  print-rxjs-scan
                  print-rxjs-skip
                  print-rxjs-take) operator-idx))