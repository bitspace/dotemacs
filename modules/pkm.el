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
  (setopt org-directory "~/Documents/metalmind")
  (setopt org-agenda-files (list org-directory))
  (setopt org-refile-targets
          '((nil :maxlevel . 3)
            (org-agenda-files :maxlevel . 3)))
  (setopt org-todo-keywords
          '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
            (sequence "WAITING(w@/!)" "STARTED(s!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING")))
  (setopt org-startup-indented t)
  (setopt org-use-fast-todo-selection t)
  (setopt org-treat-S-cursor-todo-selection-as-state-change nil)
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
