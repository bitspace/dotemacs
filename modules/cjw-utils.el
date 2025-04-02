;;; cjw-utils.el --- Utility functions -*- lexical-binding: t; -*-

;;; Commentary:

;; A collection of utility functions

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; SPDX-License-Identifier: Unlicense

;;; Code:
(defun cjw-convert-markdown-link-to-org ()
  "Convert a markdown style hyperlink to an `org-mode' style hyperlink in the current line."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (while (re-search-forward "\\[\\(.*?\\)\\](\\(https://[^)]+\\))" (line-end-position) t)
      (replace-match "[[\\2][\\1]]"))))

(defun cjw-compress-blank-lines ()
  "Replace multiple blank lines with a single blank line throughout the buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    ;; look for two or more consecutive newline characters
    (while (re-search-forward "\\(\n[ \t]*\\)\n+" nil t)
      ;; replace them with a single newline
      (replace-match "\\1"))))

(defun cjw-enable-visual-line-mode-on-hooks (hooks)
  "Enable `visual-line-mode' for each mode specified in HOOKS."
  (dolist (hook hooks)
    (add-hook hook 'visual-line-mode)))

(defun cjw-sudo ()
  "Use TRAMP to `sudo' the current buffer."
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
             buffer-file-name))))

(defun cjw-eval-and-run-all-tests-in-buffer ()
  "Deletes all loaded tests from the runtime, evaluates the current buffer and runs all loaded tests with `ert'."
  (interactive)
  (ert-delete-all-tests)
  (eval-buffer)
  (ert 't))

(defun cjw-initialize-gptel-models ()
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
(provide 'cjw-utils)
;;; cjw-utils.el ends here
