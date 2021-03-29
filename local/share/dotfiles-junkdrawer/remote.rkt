#lang racket/base

(require racket/match
         racket/string
         racket/system)

(define (exec command-string)
  (define out (open-output-string))
  (define err (open-output-string))
  (parameterize ([current-output-port out]
                 [current-error-port err])
    (define exit-code-nonzero (system command-string #:set-pwd? #t))
    (define output-string (if exit-code-nonzero
                              (get-output-string out)
                              (get-output-string err)))
    (cons exit-code-nonzero output-string)))

(define (parse-remote-name line)
  (car (regexp-match #px"^[^\\s]+" line)))

; Assumes GitHub ssh clone
(define (parse-org-name line)
  (car (cdr (regexp-match #px":([^/]+)" line))))

; Assumes GitHub ssh clone
(define (parse-repo-name line)
  (car (cdr (regexp-match #px"/([^\\.]+)\\." line))))

(define (parse-url-type line)
  (car (cdr (regexp-match #px"\\(([^\\)]+)\\)\\s*$" line))))

(struct remote (name owner repo-name url-type))

(define (split-lines multi-line-string)
  (string-split multi-line-string #rx"\n"))

(define (remote-from-line line)
  (remote (parse-remote-name line)
          (parse-org-name line)
          (parse-repo-name line)
          (parse-url-type line)))

(define (get-wd-remotes)
  (match (exec "git remote -v")
    [(cons #f err-msg) (string-append "ERROR: " err-msg)]
    [(cons #t output)
      (map
       remote-from-line
       (split-lines output))]))

; FIXME: Don't use all-defined-out
(provide (all-defined-out))
