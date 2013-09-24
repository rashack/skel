(add-to-list 'load-path "~/.emacs.d/elisp/" t)
(setq inhibit-startup-message t)
;;(setq inhibit-startup-echo-area-message "kjell")

(setq my-emacs-dir (expand-file-name "~/.emacs.d"))
(setq bookmark-default-file (expand-file-name "bookmarks" my-emacs-dir))
(load-library "my-funs.el")

(set-variable 'bios-home (getenv "BIOS_HOME"))
(set-variable 'compilation-search-path (list bios-home))

(require 'cl)
(require 'use-package)
(require 'undo-tree)
(global-undo-tree-mode)

(load-library "my-java.el")

;;(load-file "~/.emacs.d/elisp/sqlplus.el")
;; temporary uncommented, will be functional in a later commit
;;(require 'sqlplus)

(load-library "my-cl.el")
(load-library "my-clojure.el")
(load-library "my-flymake.el")
(load-library "my-jdb.el")
(load-library "my-erlang.el")
(load-library "graphviz-dot-mode.el")
(load-library "my-scala.el")
;;(load-library "my-eclim.el")
(load-library "my-mu4e.el")
(load-and-do-if-exists (home-root "/src/gnuplot-mode/gnuplot-mode.el") nil)
(load-library "my-apl.el")
(load-library "my-cgm-stuff.el")
(load-library "my-haskell.el")
(load-library "my-html.el")
(load-library "my-vc.el")

(which-func-mode t)

(require 'dos)

;; ;; Dont crash if file not found
;; (defun load-safe (file)
;;   (condition-case () (load file) (error)))

;; ;; Don't add newlines at end of file when I go down
(setq next-line-add-newlines nil)

;; Don't insert tab characters.
(setq-default indent-tabs-mode nil)

;; Use text mode instead of fundamental mode
(setq default-major-mode
      (lambda()
	(text-mode)
;;	(turn-on-auto-fill)
	(font-lock-mode)))
;; Buffer history for commands reading buffer names (for example C-x b)
;;(load-safe "better-readbuf")

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
 '(show-paren-mismatch-face ((((class color)) (:background "purple" :foreground "white"))) t))
;(set-face-background 'region "mediumpurple4")
(set-face-background 'trailing-whitespace "navy")

;; ;; Turn on colorization
(global-font-lock-mode t)

; no mode line 3D-style highlighting
(set-face-attribute 'mode-line nil :box nil)
(display-time)
(setq display-time-24hr-format t)
(setq delete-key-deletes-forward t)
(setq visible-bell t)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq line-number-mode t)
(setq column-number-mode t)
(setq-default show-trailing-whitespace t)
(setq default-indicate-empty-lines t)
;; These three below are better turned off in .Xdefaults or .Xresources
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; replace the three above for the three below in .Xdefaults or .Xresources
;;emacs.menuBar: off
;;emacs.toolBar: off
;;emacs.verticalScrollBars: off
;; does the trick

(show-paren-mode t)
(setq-default require-final-newline t)

(custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(jde-debugger (quote ("JDEbug")))
;;  '(jde-run-applet-viewer "appletviewer")
;;  '(jde-sourcepath (quote ("~/src/trunk/src" "$JAVA_HOME")))
  '(ps-font-size (quote (7 . 8)))
  '(ps-header-font-size (quote (10 . 10)))
  '(ps-header-title-font-size (quote (12 . 12)))
  '(ps-paper-type (quote a4)))

;; default grep command is 'grep -nH -e '
(setq grep-command "bgrep -n ")

(autoload 'gtags-mode "gtags" "" t)
(gtags-mode 1)

;; show filename in titlebar
(set 'frame-title-format '(myltiple-frames "%f" ("" "%f")))
;; set current buffer's filename, and full path in titlebar
;;(setq frame-title-format '("%b" (buffer-file-name ": %f")))

(put 'narrow-to-region 'disabled nil)

(gtags-mode 1)

;; ViewMail
;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/vm/")
;;(require 'vm-autoloads)

;;(defun insert-tag (tag)
;;  "Insert a tag pair, i.e. <tag></tag>, and move the point in between them."
;;  (blahblahblah

(setq message-log-max 512)

;; mozrepl
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'javascript-mode-hook 'java-custom-setup)
(defun javascript-custom-setup ()
  (moz-minor-mode 1))
;; mozrepl end

(when window-system
  (global-hl-line-mode 1)
  (set-face-background 'hl-line "#222"))

;; Make all character after column 100 a little more visible.
;;(setq whitespace-style (quote (lines-tail))
;;      whitespace-line-column 100)
;;(global-whitespace-mode 1)

;; (require 'ido)
;; (ido-mode t)
;; (setq ido-enable-flex-matching nil)

(setq line-move-visual nil)

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

;;(load-library "my-emms.el")

;; Dont split horizontally when I don't want to (default 160?)
(setq split-height-threshold nil)
;; Dont split vertically when I don't want to (default 80?)
(setq split-width-threshold nil)

(when window-system
  (global-unset-key "\C-z"))

(transient-mark-mode nil)

(windmove-default-keybindings 'meta)

;;(server-start)
(put 'downcase-region 'disabled nil)

(add-hook 'kill-buffer-hook
	  (lambda ()
	    (let ((file-name (buffer-file-name)))
	      (when file-name
		(message (format "%s: closed" file-name))))))

(load-library "my-global-keybindings.el")

;; (put-text-property start end prop value &optional object)


;; (if (dired-move-to-filename)
;;     (add-text-properties
;;      (point)
;;      (save-excursion
;;        (dired-move-to-end-of-filename)
;;        (point))
;;      '(mouse-face highlight
;; 		  help-echo "mouse-2: visit this file in other window")))

;; (let ((map (make-sparse-keymap))
;;       (file-name "/home/kjean/src/td/hercules/code/src/com/tradedoubler/hercules/cache/keyword/service/IndexBuilder.java"))
;;   (define-key map [mouse-2] '(lambda ()
;; 			       (find-file-other-window file-name)))
;;   (put-text-property 0 (length file-name) 'keymap map file-name)
;;   (message file-name))


;; (defconst closed-buffer-name "*Closed buffers*"
;;   "The name of the buffer close is writing to")

;; (defun closed-visit-file ()
;;   (interactive)
;;   (message "++++++++++++++++ close visited file ++++++++++++++++" ))

;; (defun closed-close ()
;;   (interactive) ;; DEBUG
;;   (let ((closed (buffer-file-name)))
;;     (when (and closed (not (string= closed close-buffer-name)))
;;       (let* ((old (get-buffer close-buffer-name))
;;              (buffer (or old (get-buffer-create close-buffer-name))))
;;         (with-current-buffer buffer
;;           ;; if buffer newly created disable undo
;;           (unless old
;;             (setq buffer-undo-list t))
;;           (goto-char (point-max))
;;           (unless (bolp)
;;             (newline))
;;           (let* ((start (point))
;;                  (end (+ start (length closed))))
;;             (insert closed)
;;             (newline)
;;             (let ((map (make-sparse-keymap)))
;;               (define-key map (kbd "RET") 'close-visit-file)
;;               (define-key map [mouse-1] 'close-visit-file)
;;               (put-text-property start end 'keymap map buffer))
;;             (add-text-properties
;;              start
;;              end
;;              '(help-echo "visit this file in other window"
;;                          mouse-face highlight
;;                          face (:foreground "red")))))))))

;; ;;(setq kill-buffer-hook nil)

(add-to-list 'compilation-finish-functions
	     (lambda (buf msg)
	       (message "Jumping to end of compilation buffer (%s), msg was (%s)..." buf msg)
	       (interactive)
	       (end-of-buffer-other-window 0)
	       (other-window 1)
	       (recenter-top-bottom (- (frame-height) 4))
	       (other-window -1)))

;; Monday is, of course, the first day of the week.
(setq calendar-week-start-day 1)
(setq calendar-view-diary-initially-flag nil)
(setq calendar-view-holidays-initially-flag nil)
