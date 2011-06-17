
(setq inhibit-startup-message t)
;;(setq inhibit-startup-echo-area-message "kjell")

;; ;; Dont crash if file not found
;; (defun load-safe (file)
;;   (condition-case () (load file) (error)))

;; ;; Don't add newlines at end of file when I go down
(setq next-line-add-newlines nil)

;; Use text mode instead of fundamental mode
(setq default-major-mode
      (lambda()
	(text-mode)
;;	(turn-on-auto-fill)
	(font-lock-mode)))
;; Buffer history for commands reading buffer names (for example C-x b)
;;(load-safe "better-readbuf")

;; ;; Some useful key bindings
;;     (define-key esc-map " " 'hippie-expand)
(global-set-key [?\M-g] 'goto-line)

;; (put 'iconify-or-deiconify-frame 'disabled nil)

;; Define C-, and C-. as scoll-up and scroll-down
(defun scroll-up-one-line ()
  (interactive)
  (scroll-up 1))
(defun scroll-down-one-line ()
  (interactive)
  (scroll-down 1))
(defun scroll-other-window-up-one-line ()
  (interactive)
  (scroll-other-window 1))
(defun scroll-other-window-down-one-line ()
  (interactive)
  (scroll-other-window -1))
(global-set-key [?\C-,] 'scroll-up-one-line)
(global-set-key [?\C-.] 'scroll-down-one-line)
(global-set-key [?\C-\;] 'scroll-other-window-up-one-line)
(global-set-key [?\C-:] 'scroll-other-window-down-one-line)


(add-hook 'c-mode-hook '(lambda ()
	  (c-set-style "Stroustrup")))

(add-hook 'c++-mode-hook '(lambda ()
	  (c-set-style "Stroustrup")))

;; Some new Colors for Font-lock.
(setq font-lock-mode-normal-decoration t)
(require 'font-lock)

(setq default-frame-alist
      '(
;;; Define here the default geometry or via ~/.Xdefaults.
;;	(width . 100) (height . 60)
        (cursor-color . "red")
        (cursor-type . box)
        (foreground-color . "gray")
        (background-color . "black")))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(show-paren-match-face ((((class color)) (:background "lightblue" :foreground "black"))) t)
 '(show-paren-mismatch-face ((((class color)) (:background "purple" :foreground "white"))) t)
 '(trailing-whitespace ((t (:background "navy")))))
(set-face-background 'region "mediumpurple4")

;; ;; Turn on colorization
(global-font-lock-mode t)

;; ; Fix delete to delete forward.
;; (global-set-key (read-kbd-macro "<delete>") `delete-char)

; Define function to match a parenthesis otherwise insert a %
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

; no mode line 3D-style highlighting
(set-face-attribute 'mode-line nil :box nil)
(display-time)
(setq display-time-24hr-format t)
(setq delete-key-deletes-forward t)
(setq visible-bell t)
(setq scroll-step 1)
(setq line-number-mode t)
(setq column-number-mode t)
(setq-default show-trailing-whitespace t)
(setq default-indicate-empty-lines t)
(setq-default tool-bar-mode nil)
(setq-default menu-bar-mode nil)
(scroll-bar-mode nil)
(show-paren-mode t)
(setq-default require-final-newline t)

;; ;; MATLAB EmacsLink initiation
;; (add-to-list 'load-path "/usr/local/matlab7/java/extern/EmacsLink/lisp")
;; (autoload 'matlab-eei-connect "matlab-eei"
;;   "Connects Emacs to MATLAB's external editor interface.")

;; (autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
;; (setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
;; (autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)

;; (setq matlab-indent-function t)		; if you want function bodies indented
;; (setq matlab-verify-on-save-flag nil)	; turn off auto-verify on save
;; (defun my-matlab-mode-hook ()
;;   (setq fill-column 76)
;;   (imenu-add-to-menubar "Find"))		; where auto-fill should wrap
;; (add-hook 'matlab-mode-hook 'my-matlab-mode-hook)
;; ;; MATLAB EmacsLink initiation end

;; ;;; Commands added by calc-private-autoloads on Tue Aug  7 00:02:50 2007.
;; (autoload 'calc-dispatch	   "calc" "Calculator Options" t)
;; (autoload 'full-calc		   "calc" "Full-screen Calculator" t)
;; (autoload 'full-calc-keypad	   "calc" "Full-screen X Calculator" t)
;; (autoload 'calc-eval		   "calc" "Use Calculator from Lisp")
;; (autoload 'defmath		   "calc" nil t t)
;; (autoload 'calc			   "calc" "Calculator Mode" t)
;; (autoload 'quick-calc		   "calc" "Quick Calculator" t)
;; (autoload 'calc-keypad		   "calc" "X windows Calculator" t)
;; (autoload 'calc-embedded	   "calc" "Use Calc inside any buffer" t)
;; (autoload 'calc-embedded-activate  "calc" "Activate =>'s in buffer" t)
;; (autoload 'calc-grab-region	   "calc" "Grab region of Calc data" t)
;; (autoload 'calc-grab-rectangle	   "calc" "Grab rectangle of data" t)
;; (setq load-path (nconc load-path (list "/usr/share/emacs/site-lisp/calc")))
;; (global-set-key "\e#" 'calc-dispatch)
;; ;;; End of Calc autoloads.

(setq semanticdb-default-save-directory "~/.emacs.d/semantic.cache")

;; Enable subversion support
(add-to-list 'load-path "~/.emacs.d/elisp/" t)
(require 'vc-svn)
;;(require 'psvn)

(autoload 'gtags-mode "gtags" "" t)
(gtags-mode 1)

;; show filename in titlebar
(set 'frame-title-format '(myltiple-frames "%f" ("" "%f")))
;; set current buffer's filename, and full path in titlebar
;;(setq frame-title-format '("%b" (buffer-file-name ": %f")))

;; (looking-at "\\>") means "at end of word"
;; (looking-at "$") means "at end of line"
(defun indent-or-complete ()
  "Complete if point is at end of line, and indent line."
  (interactive)
  (if (and (looking-at "$") (not (looking-back "^\\s-*")))
      (dabbrev-expand nil))
  (indent-for-tab-command))

(add-hook 'c-mode-common-hook
	  (function (lambda ()
		      (local-set-key (kbd "<tab>") 'indent-or-complete))))


;; This is NOT working
(defun div-num ()
  "Push the number at point divided by 12 to the kill-ring."
  (interactive)
  (let (num)
    (save-excursion
      (forward-word 1)
      (set-mark-command (point))
      (backward-word)
      (copy-region-as-kill (point) (mark))
      (setq num (string-to-number (car kill-ring)))
      (push (/ num 12) kill-ring))))


;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/jde"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/eieio"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/cedet-common"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/cedet-contrib"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/elib"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/semantic"))
;(require 'jde)

(defun switch-window-buffers ()
  "Visit buffer of other window in this window and visit this buffer in other window."
  (interactive)
  (other-window 1)
  (switch-to-buffer (other-buffer (current-buffer) t))
  (other-window 1)
  (switch-to-buffer (other-buffer)))
(global-set-key "\C-xw" 'switch-window-buffers)

;; (let ((a 'a)
;;       (b 'B))
;;   (if (string-lessp a b)
;;       (message "%s is less than %s" a b)
;;     (message "%s is less than %s" b a)))

;; (setq birds '(crow canary eagle swallow))
;; (setq birdss (cons 'swallow (cons 'canary (cons 'eagle (cons  'woodpecker '())))))
;; (setcar birds 'clownfish)
;; (cons birds birds)
;; (setcdr birds '(bass borre))

(load-library "my-emms.el")

(load "~/.emacs.d/haskell-mode-2.8.0/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; Dont split horizontally when I don't want to (default 160?)
(setq split-height-threshold nil)
;; Dont split vertically when I don't want to (default 80?)
(setq split-width-threshold nil)

(server-start)
