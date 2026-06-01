;; Startup
(setq gc-cons-threshold most-positive-fixnum)
(setq package-enable-at-startup nil)

(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold (* 64 1024 1024))))

(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

(setq initial-scratch-message ";; Happy Hacking!")

;; Custom file
(setq custom-file
      (locate-user-emacs-file "custom.el"))

(load custom-file 'noerror 'nomessage)

;; Packages
(require 'package)

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

;; Magit
(use-package magit
  :commands magit-status)

(global-set-key (kbd "C-x g") #'magit-status)

;; LaTeX
(use-package tex
  :ensure auctex
  :defer t)

;; Lean4
(use-package nael
  :mode "\.lean\'"
  :commands nael)

;; Backups
(setq backup-directory-alist
      '(("." . "~/.emacs.d/backups/")))

(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-saves/" t)))

(make-directory "~/.emacs.d/backups/" t)
(make-directory "~/.emacs.d/auto-saves/" t)

;; UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)

(when (member 'modus-vivendi
              (custom-available-themes))
  (load-theme 'modus-vivendi t))

(setq frame-title-format "%b")

(setq ring-bell-function #'ignore)

(blink-cursor-mode -1)

;; Editing
(setq use-short-answers t)

(global-auto-revert-mode 1)

(column-number-mode 1)

(show-paren-mode 1)

(electric-pair-mode 1)

(global-so-long-mode 1)

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; C/C++
(add-hook
 'c-mode-common-hook
 (lambda ()
   (setq-local c-basic-offset 4)))

;; Python
(setq python-indent-offset 4)

;; History and convenience
(save-place-mode 1)

(savehist-mode 1)

(recentf-mode 1)

(setq recentf-max-saved-items 100)

;; Completion
(fido-mode 1)
