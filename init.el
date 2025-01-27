;; My emacs config - again! It feels nice to be back in emacs

;; add to load path early
(add-to-list 'load-path (concat user-emacs-directory "site-lisp"))

;; load package.el
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; technomancy's better defaults
(progn
  (unless (or (fboundp 'helm-mode) (fboundp 'ivy-mode)
	     (bound-and-true-p fido-vertical-mode)
	     (bound-and-true-p vertico-mode))
  (ido-mode t)
  (setq ido-enable-flex-matching t))
  (unless (memq window-system '(mac ns))
    (menu-bar-mode -1))
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1))

  (autoload 'zap-up-to-char "misc"
    "Kill up to, but not including, ARGth occurrence of CHAR." t)

  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)

  ;; https://www.emacswiki.org/emacs/SavePlace
  (save-place-mode 1)

  (global-set-key (kbd "M-/") 'hippie-expand)
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  (global-set-key (kbd "C-M-s") 'isearch-forward)
  (global-set-key (kbd "C-M-r") 'isearch-backward)

  (show-paren-mode 1)
  (setq-default indent-tabs-mode nil)
  (savehist-mode 1)
  (setq save-interprogram-paste-before-kill t
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
	ediff-window-setup-functon 'ediff-setup-windows-plain
	custom-file (expand-file-name "custom.el" user-emacs-directory))

  (unless backup-directory-alist
    (setq backup-directory-alist `(("." . ,(concat user-emacs-directory
						   "backups"))))))

;; Theme. Only load it if we're running in a GUI.
(setq catppuccin-flavor 'macchiato)
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (when (memq window-system '(pgtk x w32 ns))
              (load-theme 'catppuccin :no-confirm))))

;; font
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font Mono"
                    :height 120) ;; Adjust height as needed

;; line numbers
(global-display-line-numbers-mode t)

;; Enable ligatures
;; This assumes you've installed the package via MELPA.
(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
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
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; auto-match pairs (brackets, braces, parens, etc)
(electric-pair-mode 1)

;; xscheme for scheme evaluation operations
(require 'xscheme)

;; markdown-mode config
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
  "Major mode for editing Github Flavored Markdown files" t)
(add-to-list 'auto-mode-alist'("README\\.md\\'" . gfm-mode))
