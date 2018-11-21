;;; exwm-firefox-evil.el --- Firefox hotkeys to functions -*- lexical-binding: t -*-

;; Author: Sebastian Wålinder <s.walinder@gmail.com>
;; URL: https://github.com/walseb/exwm-firefox-evil
;; Version: 1.0
;; Package-Requires: ((emacs "24.4") (exwm "0.16"))
;; Keywords: extensions

;; exwm-firefox-evil.el is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; exwm-firefox-evil.el is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package implements the functions defined in exwm-firefox-core to work
;; well with evil-mode
;;
;; To get link-hints you have to define a new key like below and download a
;; link-hint addon to firefox.

;;; Code:

(require 'evil)
(require 'evil-core)
(require 'exwm-firefox-core)

;;; Mode
(defvar exwm-firefox-evil-mode-map (make-sparse-keymap))
(define-minor-mode exwm-firefox-evil-mode nil nil nil exwm-firefox-evil-mode-map)

;;;; Activation
(defvar exwm-firefox-evil-firefox-name '("Firefox" "Icecat")
  "The class name used for detecting if a firefox buffer is selected.")

(defun exwm-firefox-evil-mode-enable ()
  "Enable 'exwm-firefox-evil-mode`."
  (add-hook 'exwm-manage-finish-hook 'exwm-firefox-evil-activate))

(defun exwm-firefox-evil-mode-disable ()
  "Disable 'exwm-firefox-evil-mode`."
  (remove-hook 'exwm-manage-finish-hook 'exwm-firefox-evil-activate))

(defun exwm-firefox-evil-activate ()
  "Activates exwm-firefox mode when buffer is firefox.
Firefox variant can be assigned in 'exwm-firefox-evil-firefox-name`"
  (if (member exwm-firefox-evil-firefox-name exwm-firefox-evil-firefox-name)
      (progn
	(exwm-firefox-evil-mode 1)
	(setq exwm-input-line-mode-passthrough t))))

;;; Normal and insert mode
(defun exwm-firefox-evil-normal ()
  "Pass every key directly to Emacs."
  (interactive)
  (setq exwm-input-line-mode-passthrough t))

(defun exwm-firefox-evil-insert ()
  "Pass every key to firefox."
  (interactive)
  (setq exwm-input-line-mode-passthrough nil))

(add-hook 'evil-normal-state-entry-hook 'exwm-firefox-evil-normal)
(add-hook 'evil-insert-state-entry-hook 'exwm-firefox-evil-insert)

;;;; Implicitly enter insert mode
(defvar exwm-firefox-evil-insert-on-new-tab t
  "If non-nil, auto enter insert mode after opening new tab.")

;; Auto enter insert mode on some actions
(if exwm-firefox-evil-insert-on-new-tab
    (advice-add #'exwm-firefox-core-tab-new :after #'evil-insert-state))

(advice-add #'exwm-firefox-core-toggle-focus-search-bar :after #'evil-insert-state)
(advice-add #'exwm-firefox-core-find :after #'evil-insert-state)
(advice-add #'exwm-firefox-core-quick-find :after #'evil-insert-state)

;;; Keys
;; Basic movements
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "k") 'exwm-firefox-core-up)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "j") 'exwm-firefox-core-down)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "h") 'exwm-firefox-core-left)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "l") 'exwm-firefox-core-right)

;; Move by page
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "C-f") 'exwm-firefox-core-page-down)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "C-b") 'exwm-firefox-core-page-up)

;; Move by half page
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "C-u") 'exwm-firefox-core-half-page-up)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "C-d") 'exwm-firefox-core-half-page-down)

;; Move to top/bot
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "g g") 'exwm-firefox-core-top)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "G") 'exwm-firefox-core-bottom)

;; Tab movement
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "J") 'exwm-firefox-core-tab-next)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "K") 'exwm-firefox-core-tab-previous)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "x") 'exwm-firefox-core-tab-close)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "t") 'exwm-firefox-core-tab-new)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "0") 'exwm-firefox-core-tab-first)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "$") 'exwm-firefox-core-tab-last)

;; Reload page
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "r") 'exwm-firefox-core-reload)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "R") 'exwm-firefox-core-reload-override-cache)

;; History
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "L") 'exwm-firefox-core-history-forward)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "H") 'exwm-firefox-core-history-backward)

;; Search
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "o") 'exwm-firefox-core-toggle-focus-search-bar)

;; Find
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "/") 'exwm-firefox-core-quick-find)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "n") 'exwm-firefox-core-find-next)
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "N") 'exwm-firefox-core-find-previous)

;; Pass through esc when in normal mode
(evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "<escape>") 'exwm-firefox-core-cancel)

(provide 'exwm-firefox-evil)

;;; exwm-firefox-evil.el ends here
