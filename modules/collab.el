;;; collab.el --- emacs init - collaborative related packages and settings  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

(setq user-mail-address "chris@bitspace.org")
(setq user-full-name "Chris Woods")

(defun cjw-gnus-group-list-subscribed-groups ()
  "List all subscribed groups with or without unread messages."
  (interactive)
  (gnus-group-list-all-groups 5))

;; gnus
(use-package gnus
  :bind
  (("C-c o g" . gnus)
   (:map gnus-group-mode-map
         ("o" . cjw-gnus-group-list-subscribed-groups))
   (:map gnus-summary-mode-map
         ("C-c a" . cjw-gnus-summary-archive)))
  :custom
  (gnus-directory (concat user-emacs-directory "gnus"))
  (gnus-init-file (concat user-emacs-directory "gnus.el"))
  (gnus-message-archive-group (format-time-string "sent.%Y"))
  (gnus-gcc-mark-as-read t)
  (gnus-search-use-parsed-queries t)
  (gnus-auto-select-next nil)
  (gnus-paging-select-next nil)
  (gnus-summary-stop-at-end-of-message t)
  (gnus-mime-display-multipart-related-as-mixed t)
  (gnus-auto-select-first nil)
  (gnus-summary-display-arrow nil)
  (gnus-thread-sort-functions
   '(gnus-thread-sort-by-most-recent-date
     (not gnus-thread-sort-by-number)))
  (gnus-show-threads t)
  (gnus-sum-thread-tree-false-root nil)
  (gnus-sum-thread-tree-root nil)
  (gnus-sum-thread-tree-indent " ")
  (gnus-sum-thread-tree-vertical "│")
  (gnus-sum-thread-tree-leaf-with-other "├─► ")
  (gnus-sum-thread-tree-single-leaf "╰─► ")
  (gnus-summary-line-format (concat
                             "%0{%U%R%z%}"
                             "%3{│%}%1{%&user-date;%}%3{│%}"
                             "%4{%-20,20f%}"
                             " "
                             "%1{%B%}"
                             "%s\n"))

  (gnus-user-date-format-alist '((t . "%Y-%m-%d (%a)")
                                 gnus-thread-sort-functions '(gnus-thread-sort-by-date)))
  :config
  (setq gnus-select-method '(nnimap "gmail"
                                    (nnimap-address "imap.googlemail.com")
                                    (nnimap-server-port "imaps")
                                    (nnimap-stream ssl)))
  (setq smtpmail-smtp-server "smtp.googlemail.com"
        smtpmail-smtp-service 587
        gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]"))

(provide 'collab)
;;; collab.el ends here
