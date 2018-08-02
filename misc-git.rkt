#!/usr/bin/env racket
#lang racket/base

(require "../lib/racket/git/remote.rkt")

(define (displayln-remote a-remote)
  (displayln (string-append "remote name: " (remote-name a-remote)))
  (displayln (string-append "org name:    " (remote-owner a-remote)))
  (displayln (string-append "repo name:   " (remote-repo-name a-remote)))
  (displayln (string-append "url type:    " (remote-url-type a-remote))))

(define remotes (get-wd-remotes))

(for ([r remotes])
  (displayln-remote r))
