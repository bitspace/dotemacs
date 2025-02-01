;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GNU Emacs configuration.
;; Very much a work in progress after Emacs bankruptcy.
;; I use Linux, macOS, and Windows regularly. The desire is to have a single
;; emacs init that works regardless of platform. Additionally, I interact with
;; several Linux systems remotely via ssh; ideally my emacs init will work there
;; too.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; start the server.
;; TODO: make this conditional on whether or not it's already running.
;; TODO: set up emacs as a service - homebrew service, probably - and figure out how to invoke that
;; and use either the GUI or the tty version as appropriate.
(server-start)

;; add local lisp early in loading process
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

;; load my utilities
(require 'lisppets)

;; package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; load technomancy's better-defaults
(require 'better-defaults)

;; theme
(setq catppuccin-flavor 'macchiato)
(load-theme 'catppuccin :no-confirm)

;; line numbers
(global-display-line-numbers-mode t)
;; column number in modeline
(column-number-mode t)

;; font
(when (member "JetBrainsMono Nerd Font Mono" (font-family-list))
  (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono-16"))

;; ligatures
;; This assumes you've installed the package via MELPA.
(use-package ligature
  :config
  ;; Enable all ligatures globally
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
                               "\\\\" "://"))
  (global-ligature-mode t))

;; match parens and other pair symbols
(electric-pair-mode 1)

;; yaml mode
(require 'yaml-mode)

;; Add yaml-mode for .yml and .yaml files
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; Smart indent on ENTER
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; soft wrap in text modes that are not programming languages
;; TODO: add markdown-mode, not available until I've installed and enabled markdown-mode
(cjw/enable-visual-line-mode-on-hooks
 '(text-mode-hook
   org-mode-hook))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Org functions available across all of Emacs (not just in org buffers)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; TODO state keywords
(setq org-todo-keywords
      '((sequence "TODO" "IN PROGRESS" "|" "CANCELLED" "DONE")))

;; Prefer headline indent rather than lots of stars
(setq org-startup-indented t)

;; overwrite selection with yank
(delete-selection-mode 1)

;; dired ls fix for macos
(setq insert-directory-program "/opt/homebrew/bin/gls")
