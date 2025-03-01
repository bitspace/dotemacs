;; init.el --- core Emacs configuration and initialization -*- lexical-binding: t; -*-
;; Copyright © 2025
;; SPDX-License-Identifier: Unlicense
;; Author: Chris Woods <chris@bitspace.org>

;; load custom file early to set up `package-selected-packages'
(setopt custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; conditionally start server. Do not start when running Linux because I'm running it as a systemd service.
(if (memq system-type '(darwin windows-nt))
    (server-start))

;; Add my local lisp directory to load-path
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

;; Load my utility functions
(use-package cjw-utils)

;; load technomancy's better-defaults
(use-package better-defaults)

;; dired-x
(use-package dired-x)

;; lsp
(use-package lsp-mode
  :commands lsp
  :hook
  (sh-mode . lsp))

(use-package lsp-ui)

;; use Emacs's pin entry
(setenv "GPG_AGENT_INFO" nil)

;; set up auth source. The sources listed here should not be committed to a remote source control repo.
(setopt auth-sources
      '((:source "~/.config/emacs/secrets/.authinfo.gpg")))

;; numbered lines
(setopt global-display-line-numbers-mode t)
;; column number and line number in modeline
(setopt column-number-mode t)
(setopt line-number-mode t)

;; restore the "legacy" way of navigating lines (not visual, but logical)
(setopt line-move-visual nil)

;; double spaces at sentence end is for 90 year olds
(setopt sentence-end-double-space nil)

;; make switching windows easier.
(global-set-key (kbd "M-o") 'other-window)

;; prettier underlines?
(setopt x-underline-at-descent-line nil)
(setopt switch-to-buffer-obey-display-actions t)
(setopt show-trailing-whitespace nil)
(setopt indicate-buffer-boundaries 'left)
(pixel-scroll-precision-mode)

(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font Mono"
                    :height 140)

(load-theme 'catppuccin :no-confirm)

;; Enable ligatures
;; This assumes you've installed the package via MELPA.
(use-package ligature
  :config
  ;; Enable ligatures in all possible modes
  (ligature-set-ligatures 't '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                               ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                               "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                               "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                               "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                               "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                               "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                               "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                               ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                               "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                               "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                               "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                               "\\\\" "://" "ff" "fi" "ffi"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; auto-match pairs (brackets, braces, parens, etc)
(electric-pair-mode 1)

;; which-key shows keybinding completions
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; enable isearch motion
(setopt isearch-allow-motion t)

;; set some better options on the minibuffer
(setopt enable-recursive-minibuffers t) ; use minibuffer while in minibuffer
(setopt completion-cycle-threshold 1) ; TAB to cycle candidates
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
(use-package yaml-mode)

;; handle .yaml and .yml files with yaml-mode
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
;; smart indent yaml on ENTER
(add-hook 'yaml-mode-hook
          #'(lambda ()
              (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; soft wrap in text modes that are not programming languages
(cjw/enable-visual-line-mode-on-hooks
 '(text-mode-hook
   org-mode-hook
   markdown-mode-hook))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :ensure nil
  :config
  (setopt org-M-RET-may-split-line '((default . nil)))
  (setopt org-insert-heading-respect-content t)
  (setopt org-log-done 'time)
  (setopt org-log-into-drawer t)
  (setopt org-directory "~/Documents/metalmind")
  (setopt org-agenda-files (list org-directory))
  (setopt org-todo-keywords
        '((sequence "TODO(t))" "WAIT(w!)" "|" "CANCEL(c!)" "DONE(d!)")))
  (setopt org-startup-indented t)
  (setopt org-inlinetask-show-first-star t)
  (set-face-attribute 'org-level-8 nil :weight 'bold :inherit 'default)
  (set-face-attribute 'org-level-7 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-6 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-5 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-4 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-3 nil :inherit 'org-level-8 :height 1.1)
  (set-face-attribute 'org-level-2 nil :inherit 'org-level-8 :height 1.2)
  (set-face-attribute 'org-level-1 nil :inherit 'org-level-8 :height 1.3)
  (setopt org-cycle-level-faces nil)
  (setopt org-n-level-faces 4)
  ;; Document Title
  (set-face-attribute 'org-document-title nil
                      :height 1.3
                      :foreground 'unspecified
                      :inherit 'org-level-8)
  (setopt org-hide-leading-stars t)
  (setopt org-hide-emphasis-markers t)
  (setopt org-confirm-babel-evaluate nil)
  )


;; org-superstar
(use-package org-superstar)

(add-hook 'org-mode-hook
          (lambda ()
            (org-superstar-mode 1)
            (variable-pitch-mode 1)))

;; org inline tasks
(use-package org-inlinetask)
(set-face-attribute 'org-inlinetask nil
                    :foreground 'unspecified
                    :inherit 'bold)

(with-eval-after-load 'org-superstar
  (set-face-attribute 'org-superstar-item nil :height 1.2)
  (set-face-attribute 'org-superstar-header-bullet nil :height 1.2)
  (set-face-attribute 'org-superstar-first nil :foreground "#0000e1"))
(setopt org-superstar-cycle-headline-bullets nil)
;; Hide away leading stars on terminal
(setopt org-superstar-leading-fallback ?\s)

;; Make org functions available across all of Emacs instead of just in an org-mode buffer
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; org-babel: languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((scheme . t)))

;; overwrite selection with yank
(delete-selection-mode 1)

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

;; projectile
(projectile-mode 1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; magit
(use-package magit)
(put 'upcase-region 'disabled nil)
;; forge
(with-eval-after-load 'magit
  (use-package forge))

;; ido. better-defaults doesn't enable this concurrently with other completion engines like helm, ivy, fido, or vertico.
;; TBD: this vs. the other completion engines, especially with some new capability in Emacs 30.1?
(ido-mode t)
(setopt ido-everywhere t)
(setopt ido-enable-flex-matching t)

;; gptel
;; these additional models are still WIP, not functional yet
(gptel-make-gemini "Gemini"
  :stream t)
(gptel-make-perplexity "Perplexity"
  :stream t)
(gptel-make-anthropic "Anthropic"
  :stream t)
(gptel-make-openai "Groq"
  :host "api.groq.com"
  :endpoint "/openai/v1/chat/completions"
  :stream t)
(gptel-make-openai "GitHub Models"
  :host "models.inference.ai.azure.com"
  :endpoint "/chat/completions?api-version=2024-05-01-preview"
  :stream t)
(global-set-key (kbd "C-c RET") 'gptel-send)
(add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
(add-hook 'gptel-post-response-hook 'gptel-end-of-response)
