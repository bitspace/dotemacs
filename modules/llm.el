;;; llm.el --- packages and options related to large language model integrations with emacs  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Chris Woods
;; Author: Chris Woods <chris@bitspace.org>
;; Keywords: lisp

;;; Commentary:


;;; Code:
(add-hook 'after-make-frame-functions #'cjw/initialize-gptel-models)

(provide 'llm)
;;; llm.el ends here
