;; early-init.el --- early initialization -*- lexical-binding: t; -*-
;; Copyright © 2025
;; SPDX-License-Identifier: Unlicense
;; Author: Chris Woods <chris@bitspace.org>

;; set up package.el and elpa sources
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-hook 'before-init-hook 'package-initialize)
