;;; prog.el --- options related to programming       -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)

;; ediff
(setopt ediff-split-window-function 'split-window-horizontally)
(setopt ediff-keep-variants nil)
(setopt ediff-window-setup-function 'ediff-setup-windows-plain)
(setopt ediff-diff-options "-w")

;; auto-match pairs (brackets, braces, parens, etc)
(electric-pair-mode 1)

(setopt tab-always-indent 'complete) ; TAB tries to complete, else indent
(setopt completion-styles '(basic initials substring))
(setopt completion-auto-help 'always) ; another option is 'lazy'
(setopt completions-max-height 20)
(setopt completions-detailed t)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completions-auto-select 'second-tab)
(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

;; yaml-mode
(use-package yaml-mode
  :hook (yaml-mode . (lambda ()
                       (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

;; handle .yaml and .yml files with yaml-mode
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; json and jsonc
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.jsonc\\'" . jsonc-mode))

;; xscheme for scheme evaluation operations
(use-package xscheme)

;; markdown-mode config
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
  "Major mode for editing Github Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;; magit
(use-package magit)

;; forge
(with-eval-after-load 'magit
  (use-package forge))

;; lsp
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c C-l")
  :hook
  (dockerfile-ts-mode . lsp)
  (html-mode . lsp)
  (java-mode . lsp)
  (json-mode . lsp)
  (markdown-mode . lsp)
  (python-mode . lsp)
  (sh-mode . lsp)
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(lsp-treemacs-sync-mode 1)

(define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)

;; dap
(use-package dap-mode
  :after
  lsp-mode
  :config
  (dap-auto-configure-mode))

(use-package dap-java :ensure nil)

(provide 'prog)
;;; prog.el ends here
