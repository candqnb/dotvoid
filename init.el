;; Startup
(setq gc-cons-threshold most-positive-fixnum)
(setq package-enable-at-startup nil)

(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold (* 64 1024 1024))))

;; Custom file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;; Packages
(require 'package)

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

(use-package magit
  :commands (magit-status))

(global-set-key (kbd "C-x g") #'magit-status)

;; Backups
(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups/")))

(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-saves/" t)))

(make-directory "~/.emacs.d/backups/" t)
(make-directory "~/.emacs.d/auto-saves/" t)

;; UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load-theme 'modus-vivendi t)

(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

(setq initial-scratch-message ";; Happy Hacking!")

(setq ring-bell-function 'ignore)

(setq frame-title-format "%b")

(blink-cursor-mode -1)

;; Editing
(fset 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode 1)

(column-number-mode 1)

(show-paren-mode 1)

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

(global-so-long-mode 1)

(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq-default standard-indent 4)

;; Completion
(ido-mode 1)
(ido-everywhere 1)
