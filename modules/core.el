;;; core.el --- core emacs capabilities              -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:
;; Basic Emacs functionality here.

;;; Code:

;; load custom file early to set up `package-selected-packages'
(setopt custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; conditionally start server. Do not start when running Linux because I'm running it as a systemd service.
(if (memq system-type '(darwin windows-nt))
    (server-start))

;; start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; load auth-sources early, only on frame visibility
;; (add-hook 'after-make-frame-functions #'auth-source-sync)

;; Load my utility functions
(use-package cjw-utils)

;; coding system when using the clipboard
(setopt selection-coding-system 'utf-8)

;; regex style for re-builder
(require 're-builder)
(setopt reb-re-syntax 'string)

;; unset `C-x C-v' which is bound by default to `find-alternate-file'.
;; unbinding it frees it up to be a prefix if desired.
(keymap-global-unset "C-x C-v")

;; utility to make unique buffer names
(use-package uniquify)
(setopt uniquify-buffer-name-style 'forward)

;; remember where I was in any previously-visited file
(save-place-mode 1)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(setopt save-interprogram-paste-before-kill t
        apropos-do-all t
        load-prefer-newer t
        backup-by-copying t
        read-file-name-completion-ignore-case t
        read-buffer-completion-ignore-case t
        completion-ignore-case t)

(unless backup-directory-alist
  (setopt backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))))

;; dired-x
(use-package dired-x)

;; set up auth source. The sources listed here should not be committed to a remote source control repo.
(setopt auth-sources
        '((:source "~/.config/emacs/secrets/.authinfo.gpg")))

;; make switching windows easier.
(global-set-key (kbd "M-o") 'other-window)

;; indent region
(global-set-key (kbd "C-c i") 'indent-region)

;; browse url
;; (setq browse-url-browser-function 'browse-url-chrome)
(global-set-key (kbd "C-c u") 'browse-url)

;; enable isearch motion
(setopt isearch-allow-motion t)

;; set some better options on the minibuffer
(setopt enable-recursive-minibuffers t) ; use minibuffer while in minibuffer
(setopt completion-cycle-threshold 1) ; TAB to cycle candidates

;; allow upcase-region
(put 'upcase-region 'disabled nil)

;; mwim - move where i mean
(global-set-key (kbd "C-a") 'mwim-beginning)
(global-set-key (kbd "C-e") 'mwim-end)

;; replace default info/help keys with helpful
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h x") #'helpful-command)
(global-set-key (kbd "C-c C-d") #'helpful-at-point)
(global-set-key (kbd "C-h f") #'helpful-function)

(use-package link-hint
  :ensure t
  :bind
  ("C-c l o" . link-hint-open-link)
  ("C-c l c" . link-hint-copy-link))

(use-package recentf
  :hook (after-init . recentf-mode))
;;
;;; attempting to hand-roll what spacemacs refers to as "compleseus"
;;
(use-package auto-highlight-symbol
  :config
  (global-auto-highlight-symbol-mode t))

;; consult
;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ;; ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

;; marginalia
(use-package marginalia
  ;; bind `marginalia-cycle' locally in the minibuffer. To make the binding;; available in the *Completions* buffer, add it to the `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; embark
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; hide the modeline of the embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; embark integration with consult
(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; nerd icons in completions
(use-package nerd-icons-completion
  :after marginalia
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode))

;; orderless for filtering completions
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; prescient for sorting completions (orderless does not sort)
(use-package prescient
  :custom
  (prescient-aggressive-file-save t)
  (prescient-sort-length-enable nil)
  (prescient-sort-full-matches-first t)
  (prescient-history-length 200)
  (prescient-frequency-decay 0.997)
  (prescient-frequency-threshold 0.05)
  :config
  (prescient-persist-mode 1))

(use-package vertico
  :custom
  (vertico-scroll-margin 0) ;; different scroll margin
  (vertico-count 6) ;; show more candidates
  (vertico-resize t) ;; grow and shrink the vertico minibuffer
  (vertico-cycle t) ;; enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; vertico-posframe - display vertico completions in a modal frame
(use-package vertico-posframe
  :init
  (vertico-posframe-mode)
  :custom
  (vertico-posframe-parameters
   '((left-fringe . 8)
     (right-fringe . 8))))

;; prescient integration with vertico
(use-package vertico-prescient
  :demand t
  :after vertico prescient
  :custom
  (vertico-prescient-enable-sorting t)
  (vertico-prescient-override-sorting nil)
  (vertico-prescient-enable-filtering nil)
  :config
  (vertico-prescient-mode 1))

(use-package savehist
  :init
  (savehist-mode))

(use-package emacs
  :custom
  ;; enable indentation + completion with the TAB key
  (tab-always-indent 'complete)
  ;; auto-revert: if there are changes on disk but no changes in buffer, automatically load from disk
  (global-auto-revert-mode t)
  ;; Emacs 30 and newer: disable Ispell completion function
  (text-mode-ispell-word-completion nil)
  ;; support opening new minibuffers from within existing minibuffers
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode. Vertico commands are
  ;; hidden in normal buffers. This setting is useful beyond Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  )

(provide 'core)
;;; core.el ends here
