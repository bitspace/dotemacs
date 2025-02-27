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

;; dired-x
(require 'dired-x)

;; lsp
(use-package lsp-mode
  :commands lsp
  :hook
  (sh-mode . lsp))

(use-package lsp-ui)

;; github copilot
(use-package copilot)
(add-hook 'prog-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; use Emacs's pin entry
(setenv "GPG_AGENT_INFO" nil)

;; set up auth source. The sources listed here should not be committed to a remote source control repo.
(setq auth-sources
      '((:source "~/.config/emacs/secrets/.authinfo.gpg")))

;; numbered lines
(setopt global-display-line-numbers-mode t)
;; column number and line number in modeline
(setopt column-number-mode t)
(setopt line-number-mode t)

;; restore the "legacy" way of navigating lines (not visual, but logical)
(setq line-move-visual nil)

;; double spaces at sentence end is for 90 year olds
(setq sentence-end-double-space nil)

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
(setq isearch-allow-motion t)

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
(setq org-startup-indented t)

;; org-superstar
(require 'org-superstar)

;; Make org much nicer - see org-superstar-mode demo reel
;; https://github.com/integral-dw/org-superstar-mode/blob/master/DEMO.org
;;; Titles and Sections
;; hide #+TITLE: - I actually don't want to, leaving commented for example
                                        ;(setq org-hidden-keywords '(title))
;; set basic title font
(set-face-attribute 'org-level-8 nil :weight 'bold :inherit 'default)
;; Low levels are unimportant => no scaling
(set-face-attribute 'org-level-7 nil :inherit 'org-level-8)
(set-face-attribute 'org-level-6 nil :inherit 'org-level-8)
(set-face-attribute 'org-level-5 nil :inherit 'org-level-8)
(set-face-attribute 'org-level-4 nil :inherit 'org-level-8)
;; Top ones get scaled the same as in LaTeX (\large, \Large, \LARGE)
(set-face-attribute 'org-level-3 nil :inherit 'org-level-8 :height 1.2) ;\large
(set-face-attribute 'org-level-2 nil :inherit 'org-level-8 :height 1.44) ;\Large
(set-face-attribute 'org-level-1 nil :inherit 'org-level-8 :height 1.728) ;\LARGE
;; Only use the first 4 styles and do not cycle.
(setq org-cycle-level-faces nil)
(setq org-n-level-faces 4)
;; Document Title
(set-face-attribute 'org-document-title nil
                    :height 1.4
                    :foreground 'unspecified
                    :inherit 'org-level-8)

(add-hook 'org-mode-hook
          (lambda ()
            (org-superstar-mode 1)
            (variable-pitch-mode 1)))

;; org inline tasks
(require 'org-inlinetask)
(setq org-inlinetask-show-first-star t)
;; less gray
(set-face-attribute 'org-inlinetask nil
                    :foreground 'unspecified
                    :inherit 'bold)

(with-eval-after-load 'org-superstar
  (set-face-attribute 'org-superstar-item nil :height 1.2)
  (set-face-attribute 'org-superstar-header-bullet nil :height 1.2)
  (set-face-attribute 'org-superstar-first nil :foreground "#0000e1"))
;; Stop cycling bullets to emphasize hierarchy of headlines.
(setq org-superstar-cycle-headline-bullets nil)
;; hide leading things
(setq org-hide-leading-stars t)
;; Hide away leading stars on terminal
(setq org-superstar-leading-fallback ?\s)

;; Make org functions available across all of Emacs instead of just in an org-mode buffer
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; TODO state keywords
(setq org-todo-keywords
      '((sequence "TODO" "IN PROGRESS" "|" "CANCELLED" "DEFERRED" "DONE")))

;; hide emphasis symbols
(setq org-hide-emphasis-markers t)

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
(put 'upcase-region 'disabled nil)

;; ido. better-defaults doesn't enable this concurrently with other completion engines like helm, ivy, fido, or vertico
(ido-mode t)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
