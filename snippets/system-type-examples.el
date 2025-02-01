;; Some ideas from over-thinking the potential for wanting to load config conditional on my runtime environment (OS,
;; window system, tty, etc)

;; declarative: predicates for (OS/graphic) ability combinations
(defun linux-gui-p ()
  (and (eq system-type 'gnu/linux) (display-graphic-p)))

(defun linux-tty-p ()
  (and (eq system-type 'gnu/linux) (not display-graphic-p)))

(defun mac-gui-p ()
  (and (eq system-type 'darwin) (display-graphic-p)))

(defun mac-tty-p ()
  (and (eq system-type 'darwin) (not display-graphic-p)))

(defun windows-gui-p ()
  (and (eq system-type 'windows-nt) (display-graphic-p)))

(defun windows-tty-p ()
  (and (eq system-type 'windows-nt) (display-graphic-p)))

;; a more functional approach. I am not sure I like this.
(defun system-specific-config (system-type graphic-p)
  "Applies system-specific configuration based on system type and graphics."
  (cond
   ((and (eq system-type 'gnu/linux) graphic-p)
    (message "Linux GUI config")
    (require 'some-linux-gui-package))
   ((and (eq system-type 'gnu/linux) (not graphic-p))
    (message "Linux TTY config")
    (require 'some-linux-tty-package))
   ((and (eq system-type 'darwin) graphic-p)
    (message "macOS GUI config")
    (require 'some-macos-gui-package))
   ((and (eq system-type 'darwin) (not graphic-p))
    (message "macOS TTY config")
    (require 'some-macos-tty-package))
   ((and (eq system-type 'windows-nt) graphic-p)
    (message "Windows GUI config")
    (require 'some-windows-gui-package))
   ((and (eq system-type windows-nt) (not graphic-p))
    (message "Windows TTY config")
    (require 'some-windows-tty-package))))

;; usage:
(system-specific-config (system-type display-graphic-p))

;; example setting a font
(defun get-font-size (system-type graphic-p)
  (cond
   ((and (eq system-type 'gnu/linux) graphic-p) 12)
   ((and (eq system-type 'gnu/linux) (not graphic-p)) 8)
   ((and (eq system-type 'darwin) graphic-p) 14)
   ((and (eq system-type 'darwin) (not graphic-p)) 10)
   ((and (eq system-type 'windows-nt) graphic-p) 16)
   ((and (eq system-type 'windows-nt) (not graphic-p)) 12)
   (t 10)))

(get-font-size ('gnu/linux t))

;; this one is a "data-driven" approach using an association list to store the configuration for each system type and
;; display combination. Could also use a hash table.
;; This is also more complicated than I would like, but it might prove elegant as my configuration grows.
(defvar system-configs
  '((gnu/linux (t . some-linux-gui-package) (nil . some-linux-tty-package))
    (darwin (t . some-macos-gui-package) (nil . some-macos-tty-package))
    (windows-nt (t . some-windows-gui-package) (nil . some-windows-tty-package))))

(defun system-specfic-config (system-type graphic-p)
  (let ((config (assoc system-type system-configs)))
    (when config
      (let ((package (cdr (assoc graphic-p (cdr config)))))
        (when package
          (message (format "%s %s config" system-type (if graphic-p "GUI" "TTY")))
          (require package))))))

;; usage
(system-specific-config (system-type display-graphic-p))

;; font size eample (data-driven)
(defun get-font-size (system-type graphic-p)
  (let ((config (assoc system-type system-configs)))
    (when config
      (let ((size (if graphic-p 1 8)))
        size))))

(set-face-attribute 'default nil :font (format "Monospace:pixelsize=%d" (get-font-size system-type (display-graphic-p))))
