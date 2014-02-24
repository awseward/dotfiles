(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq backup-directory-alist `(("." . "~/.emacs_autosaves")))
(setq js-indent-level 2)

(add-to-list 'load-path "~/.emacs.d/")

(require 'color-theme)
(color-theme-initialize)
(color-theme-billw)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(completions-format (quote vertical))
 '(indent-tabs-mode nil)
 '(standard-indent 2)
 '(vc-display-status t)
 '(vc-follow-symlinks t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

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
