(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq backup-directory-alist `(("." . "~/.emacs_autosaves")))
(setq js-indent-level 2)
;;(setq sgml-basic-offset 2)

;;(add-hook 'html-mode-hook
;;        (lambda ()
;;          ;; Default indentation is usually 2 spaces, changing to 4. <- DISREGARD
;;          (set (make-local-variable 'sgml-basic-offset) 2)))

;;(add-hook 'smgl-mode-hook
;;    (lambda ()
;;      ;; Default indentation to 2, but let SGML mode guess, too.
;;      (set (make-local-variable 'sgml-basic-offset) 2)
;;      (sgml-guess-indent)))
