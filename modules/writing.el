;;; writing.el --- dependencies, configuration options related to writing in emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods

;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

(delete-selection-mode 1)

;; auto-insert
(use-package autoinsert)
(setq auto-insert-directory (concat user-emacs-directory "snippets"))
(add-to-list 'auto-insert-alist
             '(org-mode . "template.org"))
(auto-insert-mode t)

;; flycheck
(global-flycheck-mode +1)

;; company
(add-hook 'after-init-hook 'global-company-mode)

;; yasnippet
(use-package yasnippet
  :config
  (yas-global-mode))

;; which-key shows keybinding completions
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(provide 'writing)
;;; writing.el ends here
