;;; cjw-utils.el --- Utility functions -*- lexical-binding: t; -*-

;;; Commentary:

;; A collection of utility functions

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; SPDX-License-Identifier: Unlicense

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

(defun cjw/put-filename-on-clipboard ()
  "Put the filename of the current buffer's file on the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(defun cjw/initialize-gptel-models ()
  "Initializes models for gptel. Deferred this to a function because it prompts for GnuPG key."
  (interactive)
;;;; gptel

  ;; bind for `gptel-send' everywhere in Emacs
  (global-set-key (kbd "C-c RET") 'gptel-send)

;;; set up model integrations

  ;; gemini, and make the default
  (setq
   gptel-model 'gemini-pro
   gptel-backend (gptel-make-gemini "Gemini"
                   :key (gptel-api-key-from-auth-source "generativelanguage.googleapis.com" "apikey")
                   :stream t))
  ;; perplexity
  (gptel-make-perplexity "Perplexity"
    :key (gptel-api-key-from-auth-source "api.perplexity.ai" "apikey")
    :stream t)

  ;; anthropic/claude
  (gptel-make-anthropic "Anthropic"
    :key (gptel-api-key-from-auth-source "api.anthropic.com" "apikey")
    :stream t)

  ;; groq
  (gptel-make-openai "Groq"
    :host "api.groq.com"
    :endpoint "/openai/v1/chat/completions"
    :stream t
    :key (gptel-api-key-from-auth-source "api.groq.com" "apikey")
    :models '(mixtral-8x7b-32768
              llama-3.3-70b-versatile))

  ;; togetherai
  (gptel-make-openai "TogetherAI"
    :host "api.together.xyz"
    :key (gptel-api-key-from-auth-source "api.together.xyz" "apikey")
    :stream t
    :models '(mistralai/Mixtral-8x7B-Instruct-v0.1
              codellama/CodeLlama-13b-Instruct-hf
              codellama/CodeLlama-34b-Instruct-hf))

  ;; github models
  (gptel-make-openai "Github Models"
    :host "models.inference.ai.azure.com"
    :endpoint "/chat/completions"
    :stream t
    :key (gptel-api-key-from-auth-source "models.inference.ai.azure.com" "apikey")
    :models '(gpt-4o))

  ;; ollama
  (gptel-make-ollama "Ollama"
    :host "localhost:11434"
    :stream t
    :models '(gemma3:latest))

  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-hook 'gptel-post-response-hook 'gptel-end-of-response))

;; org-roam
(defun cjw/org-roam-node-insert-immediate (arg &rest args)
  "Insert an org-roam node immediately without subsequently opening the node buffer."
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(defun cjw/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun cjw/org-roam-list-notes-by-tag (tag-name)
  (mapcar #'org-roam-node-file
          (seq-filter
           (cjw/org-roam-filter-by-tag tag-name)
           (org-roam-node-list))))

(defun cjw/org-roam-refresh-agenda-list ()
  (interactive)
  (setopt org-agenda-files (cjw/org-roam-list-notes-by-tag "Project")))

(defun cjw/org-roam-project-finalize-hook ()
  "Adds the captured file to `org-agenda-files' if the capture was not aborted."
  ;; remove the hook since it was added temporarily
  (remove-hook 'org-capture-after-finalize-hook #'cjw/org-roam-project-finalize-hook)

  ;; add project file to the agenda list if the capture was confirmed
  (unless org-note-abort
    (with-current-buffer (org-capture-get :buffer)
      (add-to-list 'org-agenda-files (buffer-file-name)))))

(defun cjw/org-roam-find-project ()
  (interactive)
  ;; add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook #'cjw/org-roam-project-finalize-hook)

  ;; select a project file to open, creating it if necessary
  (org-roam-node-find
   nil
   nil
   (cjw/org-roam-filter-by-tag "Project")
   :templates
   '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
      :unnarrowed t))))

;; (global-set-key (kbd "C-c n p") #'cjw/org-roam-find-project)

(defun cjw/org-roam-capture-inbox ()
  (interactive)
  (org-roam-capture- :node (org-roam-node-create)
                     :templates '(("i" "inbox" plain "* %?"
                                   :target (file+head "inbox.org" "#+title: Inbox\n")))))

;; (global-set-key (kbd "C-c n b") #'cjw/org-roam-capture-inbox)

(defun cjw/org-roam-capture-task ()
  (interactive)
  ;; add the project file to the agenda after capture is finished
  (add-hook 'org-capture-after-finalize-hook cjw/org-roam-project-finalize-hook)

  ;; capture the new task, creating the project file if necessary
  (org-roam-capture- :node (org-roam-node-read
                            nil
                            (cjw/org-roam-filter-by-tag "Project"))
                     :templates '(("p" "project" plain "** TODO %?"
                                   :target (file+head+olp "%<%Y%m%d%H%M%S>-${slug}.org"
                                                          "#+title: ${title}\n#+category: ${title}\n#+filetags: Project"
                                                          ("Tasks"))))))

;; (global-set-key (kbd "C-c n t") #'cjw/org-roam-capture-task)

(defun cjw/org-roam-copy-todo-to-today ()
  (interactive)
  (let ((org-refile-keep t) ;; set to nil to delete the original
        (org-roam-dailies-capture-templates
         '(("t" "tasks" entry "%?"
            :target (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
        (org-after-refile-insert-hook #'save-buffer)
        today-file
        pos)
    (save-window-excursion
      (org-roam-dailies--capture (current-time) t)
      (setq today-file (buffer-file-name))
      (setq pos (point)))
    ;; only refile if the target file is different from the current file
    (unless (equal (file-truename today-file)
                   (file-truename (buffer-file-name)))
      (org-refile nil nil (list "Tasks" today-file nil pos)))))

;; When I'm ready to implement the functionality in the previous function, figure out where to put this
;; (add-to-list 'org-after-todo-state-change-hook
;;              (lambda ()
;;                (when (equal org-state "DONE")
;;                  (cjw/org-roam-copy-todo-to-today))))

(provide 'cjw-utils)
;;; cjw-utils.el ends here
