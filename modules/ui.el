;;; ui.el --- configuration related to the user interface of emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods

;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

(setopt mouse-yank-at-point t
        require-final-newline t
        visible-bell t
        frame-inhibit-implied-resize t
        warning-minimum-level :emergency)

;; numbered lines
(setopt global-display-line-numbers-mode t)

;; column number and line number in modeline
(setopt column-number-mode t)
(setopt line-number-mode t)

;; hide minor mode info in modeline
(setopt mode-line-collapse-minor-modes
        '(auto-save-mode
          company-mode
          corfu-mode
          eldoc-mode
          flycheck-mode
          flyspell-mode
          font-lock-mode
          ligature-mode
          outline-minor-mode
          which-key-mode
          yas-minor-mode))

;; restore the "legacy" way of navigating lines (not visual, but logical)
(setopt line-move-visual nil)

;; some scrolling options with potential for improved UX
(setopt scroll-conservatively 10
        scroll-margin 15)

;; double spaces at sentence end is for 90 year olds
(setopt sentence-end-double-space nil)

;;; fonts
;; default
(set-face-attribute 'default nil
                    :family "JuliaMono Nerd Font Mono"
                    :height 160)

;; nerd icons
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "JuliaMono Nerd Font Mono"))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; nerd icons completion
(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(load-theme 'ef-dark :no-confirm)

;; Enable ligatures
(use-package ligature
  :config
  ;; Enable ligatures in all possible modes
  (ligature-set-ligatures 't '("--" "---" "==" "===" "!=" "!==" "=!="
                              "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" "+++" "***" ";;" "!!"
                              "??" "???" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<:<" "<>" "<<<" ">>>"
                              "<<" ">>" "||" "-|" "_|_" "|-" "||-" "|=" "||=" "##" "###" "####"
                              "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<$"
                              "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</" "</>" "/>" "<!--" "<#--"
                              "-->" "->" "->>" "<<-" "<-" "<=<" "=<<" "<<=" "<==" "<=>" "<==>"
                              "==>" "=>" "=>>" ">=>" ">>=" ">>-" ">-" "-<" "-<<" ">->" "<-<" "<-|"
                              "<=|" "|=>" "|->" "<->" "<~~" "<~" "<~>" "~~" "~~>" "~>" "~-" "-~"
                              "~@" "[||]" "|]" "[|" "|}" "{|" "[<" ">]" "|>" "<|" "||>" "<||"
                              "|||>" "<|||" "<|>" "..." ".." ".=" "..<" ".?" "::" ":::" ":=" "::="
                              ":?" ":?>" "//" "///" "/*" "*/" "/=" "//=" "/==" "@_" "__" "???"
                              "<:<" ";;;"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; soft wrap in text modes that are not programming languages
(cjw/enable-visual-line-mode-on-hooks
 '(text-mode-hook
   org-mode-hook
   markdown-mode-hook))

;; projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setopt projectile-project-search-path '("~/projects")))
  (setopt projectile-switch-project-action #'projectile-dired)
  (setopt projectile-sort-order 'recently-active)
  (setopt projectile-enable-caching t)
  (setopt projectile-enable-caching 'persistent))

(provide 'ui)
;;; ui.el ends here
