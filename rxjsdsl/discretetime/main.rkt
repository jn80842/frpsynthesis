#! /usr/bin/env racket

#lang racket/base

(require json)
(require "api.rkt")
(require "query.rkt")

(define args (current-command-line-arguments))

(define input-query (jsexpr->synth-query (string->jsexpr (vector-ref args 0))))

(define result (make-synthesis-query input-query))

(displayln (jsexpr->string (query-result->jsexpr result)))
