;;; ui.el --- configuration related to the user interface of emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods

;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

(setopt mouse-yank-at-point t
        require-final-newline t
        visible-bell t
        frame-inhibit-implied-resize t)

;; numbered lines
(setopt global-display-line-numbers-mode t)
;; column number and line number in modeline
(setopt column-number-mode t)
(setopt line-number-mode t)

;; restore the "legacy" way of navigating lines (not visual, but logical)
(setopt line-move-visual nil)

;; some scrolling options with potential for improved UX
(setopt scroll-conservatively 10
        scroll-margin 15)

;; double spaces at sentence end is for 90 year olds
(setopt sentence-end-double-space nil)

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

;; soft wrap in text modes that are not programming languages
(cjw-enable-visual-line-mode-on-hooks
 '(text-mode-hook
   org-mode-hook
   markdown-mode-hook))

;; projectile
(projectile-mode 1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setopt projectile-sort-order 'recently-active)
(setopt projectile-enable-caching t)
(setopt projectile-enable-caching 'persistent)

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

;; nerd icons completion
(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(provide 'ui)
;;; ui.el ends here
