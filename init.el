;; init.el --- core Emacs configuration and initialization -*- lexical-binding: t; -*-
;; Copyright © 2025
;; SPDX-License-Identifier: Unlicense
;; Author: Chris Woods <chris@bitspace.org>

;; load custom file early to set up `package-selected-packages'
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; conditionally start server. Do not start when running Linux because I'm running it as a systemd service.
(if (memq system-type '(darwin windows-nt))
    (server-start))

;; Add my local lisp directory to load-path
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

;; Load my utility functions
(require 'cjw-utils)

;; load technomancy's better-defaults
(require 'better-defaults)

;; numbered lines
(setopt global-display-line-numbers-mode t)
;; column number and line number in modeline
(setopt column-number-mode t)
(setopt line-number-mode t)

;; make switching windows easier.
(global-set-key (kbd "M-o") 'other-window)

;; Consider using `windmove', provides keybindings to move window focus in cardinal directions: S-<left>, S-<right>, S-<up>, S-<down> to switch windows by direction
; (windmove-default-keybindings)

;; prettier underlines?
(setopt x-underline-at-descent-line nil)
(setopt switch-to-buffer-obey-display-actions t)
(setopt show-trailing-whitespace nil)
(setopt indicate-buffer-boundaries 'left)
(pixel-scroll-precision-mode)

(load-theme 'catppuccin :no-confirm)
(set-face-attribute 'default nil
                        :family "JetBrainsMono Nerd Font Mono"
                        :height 140)

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
(require 'yaml-mode)

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

;; Make org functions available across all of Emacs instead of just in an org-mode buffer
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; TODO state keywords
(setq org-todo-keywords
      '((sequence "TODO" "IN PROGRESS" "|" "CANCELLED" "DEFERRED" "DONE")))

;; prefer indentation for headlines rather than multiple visible stars
(setq org-startup-indented t)

;; org-babel: don't prompt for code evaluation confirmation
(setq org-confirm-babel-evaluate nil)

;; org-babel: languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((scheme . t)))

;; overwrite selection with yank
(delete-selection-mode 1)

;; xscheme for scheme evaluation operations
(require 'xscheme)

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
