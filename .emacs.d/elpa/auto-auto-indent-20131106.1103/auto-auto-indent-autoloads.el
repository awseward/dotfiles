;;; auto-auto-indent-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (auto-auto-indent-mode) "auto-auto-indent" "auto-auto-indent.el"
;;;;;;  (21303 55449 468766 300000))
;;; Generated autoloads from auto-auto-indent.el

(autoload 'auto-auto-indent-mode "auto-auto-indent" "\
Automatic automatic indentation.
Works pretty well for lisp out of the box.
Other modes might need some tweaking to set up:
If you trust the mode's automatic indentation completely, you can add to it's
init hook:

\(set (make-local-variable 'aai-indent-function)
     'aai-indent-defun)

or

\(set (make-local-variable 'aai-indent-function)
     'aai-indent-forward)

depending on whether the language has small and clearly
identifiable functions, that `beginning-of-defun' and
`end-of-defun' can find.

If on the other hand you don't trust the mode at all, but like
the cursor correction and delete-char behaviour,

you can add

\(set (make-local-variable
      'aai-after-change-indentation) nil)

if the mode indents well in all but a few cases, you can change the
`aai-indentable-line-p-function'. This is what I have in my php mode setup:

\(set (make-local-variable
      'aai-indentable-line-p-function)
     (lambda ()
       (not (or (es-line-matches-p \"EOD\")
                (es-line-matches-p \"EOT\")))))

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("auto-auto-indent-pkg.el") (21303 55449
;;;;;;  480831 400000))

;;;***

(provide 'auto-auto-indent-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; auto-auto-indent-autoloads.el ends here
