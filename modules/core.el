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

(savehist-mode 1)

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
(setq browse-url-browser-function 'browse-url-chromium)
(global-set-key (kbd "C-c u") 'browse-url)

;; enable isearch motion
(setopt isearch-allow-motion t)

;; set some better options on the minibuffer
(setopt enable-recursive-minibuffers t) ; use minibuffer while in minibuffer
(setopt completion-cycle-threshold 1) ; TAB to cycle candidates

;; helm
(use-package helm)
(helm-mode 1)

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

(provide 'core)
;;; core.el ends here
