;; init.el --- core Emacs configuration and initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; My Emacs init file

;; Copyright © 2025
;; SPDX-License-Identifier: Unlicense
;; Author: Chris Woods <chris@bitspace.org>

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

;; some Emacs packages consult `user-email-address'
(setq user-mail-address "chris@bitspace.org")

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

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(savehist-mode 1)

(setopt save-interprogram-paste-before-kill t
        apropos-do-all t
        mouse-yank-at-point t
        require-final-newline t
        visible-bell t
        load-prefer-newer t
        backup-by-copying t
        frame-inhibit-implied-resize t
        read-file-name-completion-ignore-case t
        read-buffer-completion-ignore-case t
        completion-ignore-case t
        ediff-window-setup-function 'ediff-setup-windows-plain)

(unless backup-directory-alist
  (setopt backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))))

;; dired-x
(use-package dired-x)

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

;; indent region
(global-set-key (kbd "C-c i") 'indent-region)

;; browse url
(global-set-key (kbd "C-c u") 'browse-url)

;; default fixed font
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font Mono"
                    :height 160)

;; emoji font
(set-fontset-font t '(#x1f000 . #x1faff)
                  (font-spec :family "Noto Color Emoji"))

;; nerd icons
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

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
(use-package yaml-mode
  :hook (yaml-mode . (lambda ()
                       (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  )

;; handle .yaml and .yml files with yaml-mode
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; json and jsonc
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.jsonc\\'" . jsonc-mode))

;; soft wrap in text modes that are not programming languages
(cjw-enable-visual-line-mode-on-hooks
 '(text-mode-hook
   org-mode-hook
   markdown-mode-hook))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :ensure nil
  :config
  (setopt org-M-RET-may-split-line '((default . nil)))
  (setopt org-insert-heading-respect-content t)
  (setopt org-log-done 'time)
  (setopt org-log-into-drawer t)
  (setopt org-directory "~/Documents/metalmind")
  (setopt org-agenda-files (list org-directory))
  (setopt org-refile-targets
          '((nil :maxlevel . 3)
            (org-agenda-files :maxlevel . 3)))
  (setopt org-todo-keywords
          '((sequence "TODO(t)" "STARTED(s!)" "WAIT(w!)" "|" "CANCEL(c!)" "DONE(d!)")))
  (setopt org-startup-indented t)
  (setopt org-inlinetask-show-first-star t)
  (set-face-attribute 'org-level-8 nil :weight 'bold :inherit 'default)
  (set-face-attribute 'org-level-7 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-6 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-5 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-4 nil :inherit 'org-level-8)
  (set-face-attribute 'org-document-title nil :height 1.3 :foreground 'unspecified :inherit 'org-level-8)
  (setopt org-cycle-level-faces nil)
  (setopt org-n-level-faces 4)
  (setopt org-hide-leading-stars t)
  (setopt org-hide-emphasis-markers t)
  (setopt org-confirm-babel-evaluate nil)
  :hook (org-mode . (lambda ()
                      (org-superstar-mode 1))))

(setq org-capture-templates
      '(("n" "Note" entry
         (file+headline "~/Documents/metalmind/capture.org" "Intake")
         "* %?\n  %i\n  %a\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  :TAGS: :note:")
        ("t" "Task" entry
         (file+headline "~/Documents/metalmind/tasks.org" "Tasks")
         "** TODO %?\n  %i\n  %a\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  :TAGS: :task:")
        ("p" "Project Idea" entry
         (file+headline "~/Documents/metalmind/projects.org" "Project Ideas")
         "** %?\n  - Description:\n  %i\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  :TAGS: :project_idea:")
        ("v" "Travel Plan" entry
         (file+headline "~/Documents/metalmind/travel/intake.org" "Travel Plans")
         "** %?\n  - Destination: %^{Destination}\n  - Dates: %^{Dates}\n  %i\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  :TAGS: :travel:")
        ("l" "Leisure Note" entry
         (file+headline "~/Documents/metalmind/leisure/intake.org" "Leisure")
         "** %?\n  %i\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  :TAGS: :leisure:")))

;; org-superstar
(use-package org-superstar)

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
(setopt projectile-sort-order 'recently-active)
(setopt projectile-enable-caching t)
(setopt projectile-enable-caching 'persistent)

;; magit
(use-package magit)

;; forge
(with-eval-after-load 'magit
  (use-package forge))

;; helm
(use-package helm)
(helm-mode 1)

;; allow upcase-region
(put 'upcase-region 'disabled nil)

;; ediff
(setopt ediff-split-window-function 'split-window-horizontally)
(setopt ediff-keep-variants nil)
(setopt ediff-window-setup-function 'ediff-setup-windows-plain)
(setopt ediff-diff-options "-w")

;; verb http client prefix keymapping
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

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

;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :bind
  (:map global-map
        ("M-0" . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(treemacs-start-on-boot)

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

;; which-key shows keybinding completions
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; eat-eshell-mode hook
(add-hook 'eshell-load-hook #'eat-eshell-mode)

;; An alternative - run visual commands with Eat instead of term
;; (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)

;;;; gptel

;; bind for `gptel-send' everywhere in Emacs
(global-set-key (kbd "C-c RET") 'gptel-send)

;;; set up model integrations

;; gemini, and make the default
(setq
 gptel-model 'gemini-pro
 gptel-backend (gptel-make-gemini "Gemini"
                 :key (gptel-api-key-from-auth-source "generativelanguage.googleapis.com" "apikey")
                 :stream t))
;; perplexity
(gptel-make-perplexity "Perplexity"
  :key (gptel-api-key-from-auth-source "api.perplexity.ai" "apikey")
  :stream t)

;; anthropic/claude
(gptel-make-anthropic "Anthropic"
  :key (gptel-api-key-from-auth-source "api.anthropic.com" "apikey")
  :stream t)

;; groq
(gptel-make-openai "Groq"
  :host "api.groq.com"
  :endpoint "/openai/v1/chat/completions"
  :stream t
  :key (gptel-api-key-from-auth-source "api.groq.com" "apikey")
  :models '(mixtral-8x7b-32768
            llama-3.3-70b-versatile))

;; togetherai
(gptel-make-openai "TogetherAI"
  :host "api.together.xyz"
  :key (gptel-api-key-from-auth-source "api.together.xyz" "apikey")
  :stream t
  :models '(mistralai/Mixtral-8x7B-Instruct-v0.1
            codellama/CodeLlama-13b-Instruct-hf
            codellama/CodeLlama-34b-Instruct-hf))

;; github models
(gptel-make-openai "Github Models"
  :host "models.inference.ai.azure.com"
  :endpoint "/chat/completions"
  :stream t
  :key (gptel-api-key-from-auth-source "models.inference.ai.azure.com" "apikey")
  :models '(gpt-4o))

;; ollama
(gptel-make-ollama "Ollama"
  :host "localhost:11434"
  :stream t
  :models '(gemma3:latest))

(add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
(add-hook 'gptel-post-response-hook 'gptel-end-of-response)

(provide 'init)
;;; init.el ends here
