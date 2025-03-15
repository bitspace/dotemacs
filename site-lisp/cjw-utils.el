;;; cjw-utils.el --- core Emacs configuration and initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; A collection of utility functions

;; Copyright © 2025
;; SPDX-License-Identifier: Unlicense
;; Author: Chris Woods <chris@bitspace.org>

;;; Code:

(defun cjw/convert-markdown-link-to-org ()
  "Convert a markdown style hyperlink to an `org-mode' style hyperlink in the current line."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (while (re-search-forward "\\[\\(.*?\\)\\](\\(https://[^)]+\\))" (line-end-position) t)
      (replace-match "[[\\2][\\1]]"))))

(defun cjw/compress-blank-lines ()
  "Replace multiple blank lines with a single blank line throughout the buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    ;; look for two or more consecutive newline characters
    (while (re-search-forward "\\(\n[ \t]*\\)\n+" nil t)
      ;; replace them with a single newline
      (replace-match "\\1"))))

(defun cjw/enable-visual-line-mode-on-hooks (hooks)
  "Enable `visual-line-mode' for each mode specified in HOOKS."
  (dolist (hook hooks)
    (add-hook hook 'visual-line-mode)))

(defun cjw/sudo ()
  "Use TRAMP to `sudo' the current buffer."
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
             buffer-file-name))))

(defun cjw/eval-and-run-all-tests-in-buffer ()
  "Deletes all loaded tests from the runtime, evaluates the current buffer and runs all loaded tests with `ert'."
  (interactive)
  (ert-delete-all-tests)
  (eval-buffer)
  (ert 't))

(provide 'cjw-utils)
;;; cjw-utils.el ends here
