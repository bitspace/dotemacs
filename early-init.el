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

;; bump up GC threshold. I have oodles of memory.
(setopt gc-cons-threshold (* 1024 1024 1024))

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

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
