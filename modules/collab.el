;;; collab.el --- emacs init - collaborative related packages and settings  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:

;;; Code:

(setq user-mail-address "chris@bitspace.org")
(setq user-full-name "Chris Woods")

(defun cjw/gnus-group-list-subscribed-groups ()
  "List all subscribed groups with or without unread messages."
  (interactive)
  (gnus-group-list-all-groups 5))

;; gnus
(use-package gnus
  :ensure nil
  :after (gnus-sum gnus-dired gnus-topic)
  :config
  ;;; accounts
  (setopt gnus-select-method '(nnnil nil))
  (setopt gnus-secondary-select-methods
        '((nnimap "bitspace"
                  (nnimap-address "imap.googlemail.com")
                  (nnimap-server-port "imaps")
                  (nnimap-stream ssl)
                  (nnir-search-engine imap)
                  (nnmail-expiry-target "nnimap+bitspace:[Gmail]/Trash")
                  (nnmail-expiry-wait 'immediate))
          (nnimap "consumer"
                  (nnimap-address "imap.gmail.com")
                  (nnimap-server-port "imaps")
                  (nnimap-stream ssl)
                  (nnir-search-engine imap)
                  (nnmail-expiry-target "nnimap+consumer:[Gmail]/Trash")
                  (nnmail-expiry-wait 'immediate))
          (nntp "gwene" (nntp-address "news.gwene.org"))))
  (setopt gnus-posting-styles
        '(("bitspace"
           (address "Chris Woods <chris@bitspace.org>")
           (organization "bitspace heavy industries")
           (signature-file (concat user-emacs-directory ".signature-bitspace"))
           ("X-Message-SMTP-Method" "smtp smtp.googlemail.com 587 chris@bitspace.org"))
          ("consumer"
           (address "Chris Woods <chris.woods@gmail.com>")
           (signature-file (concat user-emacs-directory ".signature-consumer"))
           ("X-Message-SMTP-Method" "smtp smtp.gmail.com 587 chris.woods@gmail.com"))))
  :bind
  (("C-c o g" . gnus)
   (:map gnus-group-mode-map
         ("o" . cjw/gnus-group-list-subscribed-groups))
   (:map gnus-summary-mode-map
         ("C-c a" . cjw/gnus-summary-archive)))
  :custom
  (gnus-asynchronous t)
  (gnus-use-cache t)
  (gnus-use-header-prefetch t)
  (gnus-directory (concat user-emacs-directory "gnus"))
  (gnus-init-file (concat user-emacs-directory "gnus.el"))
  (gnus-startup-file (concat gnus-directory "/.newsrc"))
  (gnus-cache-directory (concat gnus-directory "/news/cache"))
  (gnus-article-save-directory (concat gnus-directory "/news"))
  (gnus-kill-files-direcory (concat gnus-directory "/news"))
  (gnus-message-archive-group (format-time-string "sent.%Y"))
  (nndraft-directory (concat gnus-directory "/mail/draft"))
  (nnfolder-directory (concat gnus-directory "/mail/archive"))
  (gnus-gcc-mark-as-read t)
  (gnus-search-use-parsed-queries t)
  (gnus-auto-select-next nil)
  (gnus-paging-select-next nil)
  (gnus-summary-stop-at-end-of-message t)
  (gnus-mime-display-multipart-related-as-mixed t)
  (gnus-auto-select-first nil)
  (gnus-summary-display-arrow nil)
  (gnus-use-adaptive-scoring t)
  (gnus-thread-sort-functions
   '(gnus-thread-sort-by-most-recent-date
     (not gnus-thread-sort-by-number)))
  (gnus-show-threads t)
  (gnus-sum-thread-tree-false-root " ")
  (gnus-sum-thread-tree-root "r ")
  (gnus-sum-thread-tree-indent "  ")
  (gnus-sum-thread-tree-single-indent "◎ ")
  (gnus-sum-thread-tree-vertical "│")
  (gnus-sum-thread-tree-leaf-with-other "├─► ")
  (gnus-sum-thread-tree-single-leaf "╰─► ")
  (gnus-summary-line-format (concat "%0{%U%R%z%}"
				    "%3{│%}" "%1{%d%}" "%3{│%}"
				    "  "
				    "%4{%-20,20f%}"
				    "  "
				    "%3{│%}"
				    " "
				    "%1{%B%}"
				    "%s\n"))

  (gnus-user-date-format-alist '((t . "%Y-%m-%d (%a)")
                                 gnus-thread-sort-functions '(gnus-thread-sort-by-date))))

(provide 'collab)
;;; collab.el ends here
