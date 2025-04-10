;;; pkm.el --- packages and configuration related to personal knowledge management  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

(use-package org
  :ensure nil
  :config
  (setopt org-M-RET-may-split-line '((default . nil)))
  (setopt org-insert-heading-respect-content t)
  (setopt org-log-done 'time)
  (setopt org-log-into-drawer t)
  (setopt org-auto-align-tags nil)
  (setopt org-tags-column 0)
  (setopt org-catch-invisible-edits 'show-and-error)
  (setopt org-special-ctrl-a/e t)
  (setopt org-pretty-entities t)
  (setopt org-agenda-tags-column 0)
  (setopt org-ellipsis "…")
  (setopt org-directory "~/Documents/metalmind")
  (setopt org-default-notes-file (concat org-directory "refile.org"))
  (setopt org-agenda-files (list (concat org-directory "/agenda")))
  (setopt org-refile-targets
          '((nil :maxlevel . 9)
            (org-agenda-files :maxlevel . 9)))
  (setopt org-refile-use-outline-path t)
  (setopt org-refile-allow-creating-parent-nodes (quote confirm))
  (setopt org-agenda-dim-blocked-tasks nil)
  (setopt org-agenda-compact-blocks t)
  (setopt org-todo-keywords
          '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
            (sequence "WAITING(w@/!)" "STARTED(s!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING")))
  (setopt org-todo-state-tags-triggers
          '(("CANCELLED" ("CANCELLED" . t))
            ("WAITING" ("WAITING" . t))
            ("HOLD" ("WAITING") ("HOLD" . t))
            (done ("WAITING") ("HOLD"))
            ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
            ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
            ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))
  (setopt org-startup-indented t)
  (setopt org-treat-S-cursor-todo-selection-as-state-change nil)
  (setopt org-inlinetask-show-first-star t)
  (set-face-attribute 'org-level-8 nil :weight 'bold :inherit 'default)
  (set-face-attribute 'org-level-7 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-6 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-5 nil :inherit 'org-level-8)
  (set-face-attribute 'org-level-4 nil :inherit 'org-level-8)
  (set-face-attribute 'org-document-title nil :height 1.2 :foreground 'unspecified :inherit 'org-level-8)
  (setopt org-cycle-level-faces nil)
  (setopt org-n-level-faces 4)
  (setopt org-hide-leading-stars t)
  (setopt org-hide-emphasis-markers t)
  (setopt org-confirm-babel-evaluate nil))

;; org-modern. I'll put these into a better place later
(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars t)
  (org-modern-table t)
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

;; and org-modern-indent
(use-package org-modern-indent
  :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(setq org-capture-templates
      '(("t" "todo" entry (file "~/Documents/metalmind/refile.org")
         "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
        ("n" "note" entry (file "~/Documents/metalmind/refile.org")
         "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
        ("j" "Journal" entry (file+olp+datetree "~/Documents/metalmind/journal.org"))))

;; org inline tasks
(use-package org-inlinetask)
(set-face-attribute 'org-inlinetask nil
                    :foreground 'unspecified
                    :inherit 'bold)

;; use org for txt files too?
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

;; Make org functions available across all of Emacs instead of just in an org-mode buffer
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; org-babel: languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((scheme . t)))

(provide 'pkm)
;;; pkm.el ends here
