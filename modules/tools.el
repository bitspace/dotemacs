;;; tools.el --- options and dependencies for various tools in emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods

;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

;; verb http client prefix keymapping
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

;; eat-eshell-mode hook
(add-hook 'eshell-load-hook #'eat-eshell-mode)

;; An alternative - run visual commands with Eat instead of term
;; (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)

(provide 'tools)
;;; tools.el ends here
