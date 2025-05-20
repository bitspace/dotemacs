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

;; enable tree-sitter as broadly as supported
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; corfu. The fact that I have this in my prog module is sort of arbitrary, I guess.
(use-package corfu
  :custom
  (corfu-cycle t) ;; enable cycling for `corfu-next/previous'
  (corfu-quit-at-boundary nil) ;; never quit at completion boundary
  (corfu-quit-no-match nil) ;; never quit, even if there is no match
  (corfu-preview-current nil) ;; disable current candidate preview
  (corfu-preselect 'prompt) ;; preselect the prompt
  (corfu-on-exact-match nil) ;; configure handling of exact matches
  ;; Enable corfu only for certain modes
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))
  :init
  (global-corfu-mode))

;; prescient integration with corfu
(use-package corfu-prescient
  :demand t
  :after corfu prescient
  :custom
  (corfu-prescient-enable-sorting t)
  (corfu-prescient-override-sorting nil)
  (corfu-prescient-enable-filtering nil)
  :config
  (corfu-prescient-mode 1))

;; use dabbrev with corfu
(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

;; auto-match pairs (brackets, braces, parens, etc)
(electric-pair-mode 1)

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

;; dap
(use-package dap-mode
  :after
  lsp-mode
  :config
  (dap-auto-configure-mode))

(use-package dap-java :ensure nil)

;; pipenv
(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq pipenv-projectile-after-switch-function #'pipenv-projectile-after-switch-extended))

(provide 'prog)
;;; prog.el ends here
