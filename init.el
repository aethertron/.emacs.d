(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (counsel swiper ivy multiple-cursors))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Important variables
(setq emacs-heavy (if (string= (getenv "EMACS_HEAVY") "") nil 1))
(defconst temp-dir (expand-file-name "cache" user-emacs-directory) "Hostname-based elisp temp directories")

;; General keybinding configuration
(global-set-key (kbd "M-k") #'backward-kill-word)
(global-set-key (kbd "C-c s") #'sort-lines)
;; turn off suspend mode
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-c m") 'man)

;; Configure line wrap toggling
(progn 
  (setq-default truncate-lines t)
  (setq truncate-partial-width-windows 20)
  (global-set-key (kbd "C-c r") #'visual-line-mode))

;; Configure graphical elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Configure Lightweight Packages
;; ------------------------------
;; Configure multiple-cursors
(progn
  (require 'multiple-cursors)
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  ;; mc bindings that work in TTY
  (global-set-key (kbd "C-c j") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-c k") 'mc/mark-previous-like-this))

(progn
  ;; Backups in autosave dir
  (setq
   history-length                     1000
   backup-inhibited                   nil
   make-backup-files                  t
   auto-save-default                  t
   auto-save-list-file-name           (expand-file-name "autosave" temp-dir)
   create-lockfiles                   nil
   backup-directory-alist            `((".*" . ,(concat temp-dir "/backup/")))
   auto-save-file-name-transforms    `((".*" ,(concat temp-dir "/auto-save-list/") t)))
  (unless (file-exists-p (expand-file-name "auto-save-list" temp-dir))
    (make-directory (expand-file-name "auto-save-list" temp-dir) 1)))

;; Heavy duty
;; ----------
(if emacs-heavy
    (progn
      (server-start)
      (require 'ivy)))

