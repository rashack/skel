(add-to-list 'load-path "~/.emacs.d/elisp/" t)
(setq inhibit-startup-message t)

(setq my-emacs-dir (expand-file-name "~/.emacs.d"))
(setq bookmark-default-file (expand-file-name "bookmarks" my-emacs-dir))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(load-library "my-funs.el")
(load-library "my-string-funs.el")
(load-library "my-font-stuff.el")

(set-variable 'bios-home (getenv "BIOS_HOME"))
(set-variable 'compilation-search-path (list bios-home))

(savehist-mode t)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(require 'cl)
(my-load-use 'use-package)
(my-load-use 'dash)
(my-load-use 'undo-tree)
(global-undo-tree-mode)

(load-library "my-colours.el")
(my-colours-theme 'solarized-grey)

(load-library "my-java.el")

;;(load-file "~/.emacs.d/elisp/sqlplus.el")
;; temporary uncommented, will be functional in a later commit
;;(require 'sqlplus)

(load-library "my-misc-modes.el")
(load-library "my-recentf.el")
(load-library "my-cl.el")
(load-library "my-clojure.el")
(load-library "my-flymake.el")
(load-library "my-jdb.el")
(load-library "my-erlang.el")
(load-library "graphviz-dot-mode.el")
(load-library "my-scala.el")
;;(load-library "my-eclim.el")
(load-library "my-mu4e.el")
(load-and-do-if-exists (elisp-root "gnuplot-mode/gnuplot-mode.el") nil)
(load-library "my-apl.el")
(load-library "my-cgm-stuff.el")
(load-library "my-haskell.el")
(load-library "my-html.el")
(load-library "my-vc.el")
(load-library "my-org.el")
(load-library "my-emacs-tmp-files.el")
(load-library "my-lua-mode.el")

;; from git://jblevins.org/git/markdown-mode.git
(my-load-use 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(which-func-mode t)

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

; no mode line 3D-style highlighting
(set-face-attribute 'mode-line nil :box nil)
(display-time)
(setq display-time-24hr-format t)
(setq delete-key-deletes-forward t)
(setq visible-bell t)
(setq scroll-step 1)
(setq scroll-conservatively 50)
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
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ps-font-size (quote (7 . 8)))
 '(ps-header-font-size (quote (10 . 10)))
 '(ps-header-title-font-size (quote (12 . 12)))
 '(ps-paper-type (quote a4))
 '(safe-local-variable-values (quote ((erlang-ident-level . 2) (allout-layout . t)))))

(setq ps-lpr-command "lp")

;; default grep command is 'grep -nH -e '
;; (grep-apply-setting 'grep-command "mgrep ")
(setq grep-command "mgrep ")
;; I normally use my own script around grep and don't wat the /dev/null appended
;; (grep-apply-setting 'grep-use-null-device nil)
(setq grep-use-null-device nil)

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

;; from https://github.com/scottjad/linum-relativenumber
;; (when window-system
;;   (my-load-use 'linum-relativenumber))
(global-linum-mode 1)
;; from https://github.com/nschum/highlight-parentheses.el.git
(my-load-use 'highlight-parentheses)
(add-to-hooks 'highlight-parentheses-mode
              'emacs-lisp-mode-hook
              'erlang-mode-hook
              'clojure-mode-hook
              'haskell-mode-hook
              'javascript-mode-hook)

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

(require 'popup-switcher)
;; (setq psw-in-window-center t)
(global-set-key [f2] 'psw-switch-buffer)

(require 'desktop)
(add-to-list 'desktop-path ".")
