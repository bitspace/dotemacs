;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility functions
;; At some point this is likely to grow somewhat unwieldy and I'll want to modularize
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; convert a markdown style link to an org style link
(defun cjw/convert-markdown-link-to-org ()
  "Convert a markdown style hyperlink to an org-mode style hyperlink in the current line."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (while (re-search-forward "\\[\\(.*?\\)\\](\\(https://[^)]+\\))" (line-end-position) t)
      (replace-match "[[\\2][\\1]]"))))

;; compress repeated blank lines into one
(defun cjw/compress-blank-lines ()
  "Replace multiple blank lines with a single blank line throughout the buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    ;; look for two or more consecutive newline characters
    (while (re-search-forward "\\(\n[ \t]*\\)\n+" nil t)
      ;; replace them with a single newline
      (replace-match "\\1"))))

;; Wrapper for visual-line-mode. Additional file types can be added here.
(defun cjw/enable-visual-line-mode-on-hooks (hooks)
  "Enable visual-line-mode for each mode specified in HOOKS."
  (dolist (hook hooks)
    (add-hook hook 'visual-line-mode)))

;; utility function to load a theme only in an active window-system
(defun load-theme-if-window-system ()
  "Load the theme if running in a window-system."
  (when (memq window-system '(pgtk x w32 ns))
    (load-theme 'catppuccin :no-confirm)))

(provide 'cjw-utils)
