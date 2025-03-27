;;; early-init.el --- early initialization -*- lexical-binding: t; -*-

;; Copyright © 2025
;; SPDX-License-Identifier: Unlicense

;; Author: Chris Woods <chris@bitspace.org>

;;; Commentary:

;; Things that need to be set up before main Emacs initialization starts. The clever package staleness monitoring was cribbed straight from crafted-emacs

;;; Code:

(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "https://melpa.org/packages/"))

(require 'time-date)

(defvar cjw-package-perform-stale-archive-check t
  "Check if any package archives are stale.")

(defvar cjw-package-update-days 1
  "Threshold in days beyond when a package archive is considered stale.")

;; Define the base directory containing your modules
(let ((modules-root-dir (expand-file-name "modules" user-emacs-directory)))
  ;; Ensure the modules directory exists
  (when (file-directory-p modules-root-dir)
    ;; Find all .el or .elc files recursively within the modules directory
    (let ((lisp-files (directory-files-recursively modules-root-dir "\\.elc?$")))
      ;; For each found file, add its directory to the load-path
      (dolist (file lisp-files)
        ;; `file-name-directory` extracts the directory part of the path
        ;; `add-to-list` handles duplicates
        (add-to-list 'load-path (file-name-directory file))))))

(defun cjw-package-archive-stale-p (archive)
  "Return t if ARCHIVE is stale.

ARCHIVE is stale if the on-disk cache is older than `cjw-package-update-days' old. If `cjw-package-perform-stale-archive-check' is nil, then check is skipped."
  (let* ((today (decode-time nil nil t))
         (archive-name (expand-file-name
                        (format "archives/%s/archive-contents" archive)
                        package-user-dir))
         (last-update-time (decode-time (file-attribute-modification-time
                                         (file-attributes archive-name))))
         (delta (make-decoded-time :day cjw-package-update-days)))
    (when cjw-package-perform-stale-archive-check
      (time-less-p (encode-time (decoded-time-add last-update-time delta))
                   (encode-time today)))))

(defun cjw-package-archives-stale-p ()
  "Return t if any package archives' cache is out of date.

Check each archive listed in `package-archives'. If the on-disk cache is older than `cjw-package-update-days', return a non-nil value. Fails fast; will return t for the first stale archive found or nil if they are all up to date."
  (interactive)
  (cl-some #'cjw-package-archive-stale-p (mapcar #'car package-archives)))

(defun cjw-package-initialize ()
  "Initialize the package system."
  (when package-enable-at-startup
    (package-initialize)

    (require 'seq)
    (message "cjw-package-config: checking package archives")
    (cond ((seq-empty-p package-archive-contents)
           (progn
             (message "cjw-package-config: package archives empty, initializing")
             (package-refresh-contents)))
          ((cjw-package-archives-stale-p)
           (progn
             (message "cjw-package-config: package archives stale, refreshing")
             (package-refresh-contents t))))
    (message "cjw-package-config: package system initalized")))

;;; Initialize package system
;; Refresh archives if necessary before init file runs.
(add-hook 'before-init-hook #'cjw-package-initialize)

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(unless (memq (window-system) '(mac ns))
  (when (fboundp 'menu-bar-mode)
    (menu-bar-mode -1)))
(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

(provide 'early-init)
;;; early-init.el ends here
