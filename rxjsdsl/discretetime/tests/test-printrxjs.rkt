#lang racket

(require rackunit)
(require "../instruction.rkt")
(require "../sketch.rkt")
(require "../printrxjs.rkt")

(check-equal? (print-rxjs-program (sketch '() 0 1)) "input0")

(define sketch1 (sketch (list (insn 3 0 0 0 0)) 1 1))

(check-equal? (print-rxjs-program sketch1) "input0.map(add1)")

(define sketch2 (sketch (list (insn 3 0 0 0 0)
                              (insn 0 2 1 0 0)) 3 2))

(check-equal? (print-rxjs-program sketch2) "input0.map(add1).combineLatest(input1)")

(define sketch3 (sketch (list (insn 3 0 0 0 0)
                              (insn 0 2 1 0 0)
                              (insn 8 3 0 0 5)) 4 2))

(check-equal? (print-rxjs-program sketch3) "input0.map(add1).combineLatest(input1).take(5)")