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
  (setopt org-confirm-babel-evaluate nil)
  :hook
  (org-mode . org-modern-mode))

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
 '((css . t)
   (emacs-lisp . t)
   (java . t)
   (js . t)
   (lisp . t)
   (org . t)
   (scheme . t)
   (sql . t)
   (sqlite . t)
   (python . t)
   (shell . t)
   ))

;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documents/akasha/"))
  (org-roam-completion-everywhere t)
  (org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-dailies-directory "journal/")
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
      :unnarrowed t)
     ("l" "programming language" plain
      "* Characteristics\n\n- Family: %?\n- Inspired by:\n\n* Reference:\n\n"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("b" "book notes" plain
      (file "~/Documents/akasha/templates/book-notes.org")
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)
     ("p" "project" plain
      "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %<%I:%M %p>: %?"
      :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n I" . cjw-org-roam-node-insert-immediate)
         ("C-c n c" . org-roam-capture)
         ("C-c n J" . org-roam-dailies-capture-today)
         ("C-c n Y" . org-roam-dailies-capture-yesterday)
         ("C-c n T" . org-roam-dailies-capture-tomorrow)
         ("C-c n D" . org-roam-dailies-capture-date)
         ("C-c n j" . org-roam-dailies-goto-today)
         ("C-c n y" . org-roam-dailies-goto-yesterday)
         ("C-c n t" . org-roam-dailies-goto-tomorrow)
         ("C-c n p" . org-roam-dailies-goto-previous-note)
         ("C-c n n" . org-roam-dailies-goto-next-note)
         ("C-c n d" . org-roam-dailies-goto-date))
  :config
  (require 'org-roam-dailies)
  (require 'org-roam-protocol)
  (org-roam-db-autosync-mode))

(provide 'pkm)
;;; pkm.el ends here
