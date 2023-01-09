(defconst emacs-start-time (current-time))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(add-to-list 'load-path "~/.emacs.d/elisp/" t)
(setq inhibit-startup-message t)

(setq my-emacs-dir (expand-file-name "~/.emacs.d"))
(setq bookmark-default-file (expand-file-name "bookmarks" my-emacs-dir))
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/")

             '("MELPA Stable" . "https://stable.melpa.org/packages/"))
(package-initialize)
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))
(require 'use-package)

(load-library "my-funs.el")
(load-library "my-string-funs.el")
(load-library "my-font-stuff.el")

(set-variable 'bios-home (getenv "BIOS_HOME"))
(set-variable 'compilation-search-path (list bios-home))

(savehist-mode t)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(use-package cl
  :defer t)
(use-package dash
  :defer t
  :ensure dash)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree-saves")))
(use-package undo-tree
  :defer t
  :ensure undo-tree)
(global-undo-tree-mode)
(use-package yasnippet
  :ensure yasnippet)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(yas-reload-all)
(yas-global-mode 1)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package flycheck
  :hook (prog-mode . flycheck-mode))

;; (use-package company
;;   :defer t
;;   :ensure company)
(use-package company
  :defer t
  :hook (prog-mode . company-mode)
  :config (setq company-tooltip-align-annotations t)
          (setq company-minimum-prefix-length 1))
(add-hook 'after-init-hook 'global-company-mode)

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (ansi-color-apply-on-region (point-min) (point-max)))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(load-library "my-lsp.el")
(load-library "my-rust.el")
(load-library "my-colours.el")
(my-colours-theme 'solarized-grey)

(load-library "my-projectile.el")
(load-library "my-java.el")

;;(load-file "~/.emacs.d/elisp/sqlplus.el")
;; temporary uncommented, will be functional in a later commit
;;(require 'sqlplus)

(load-library "my-misc-modes.el")
(load-library "my-recentf.el")
(load-library "my-cl.el")
(load-library "my-clojure.el")
(load-library "my-flymake.el")
;;(load-library "my-jdb.el")
(load-library "my-navi-stack.el")
;; (load-library "my-erlang.el")
(load-library "klarna-funs.el")
(load-library "my-xml.el")
(use-package graphviz-dot-mode
  :defer t
  :ensure graphviz-dot-mode)
(load-library "my-mu4e.el")
(use-package gnuplot-mode
  :defer t
  :ensure gnuplot-mode)
;;(load-library "my-apl.el")
(load-library "my-cgm-stuff.el")
(load-library "my-html.el")
(load-library "my-org.el")
(load-library "my-emacs-tmp-files.el")
(load-library "my-lua-mode.el")
(load-library "my-ruby.el")

;; from git://jblevins.org/git/markdown-mode.git
(use-package markdown-mode
  :defer t
  :ensure markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(use-package geiser
  :defer t
  :ensure geiser)

(which-function-mode t)

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
(setq org-src-fontify-natively t)
;; These three below are better turned off in .Xdefaults or .Xresources
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; replace the three above for the three below in .Xdefaults or .Xresources
;;emacs.menuBar: off
;;emacs.toolBar: off
;;emacs.verticalScrollBars: off
;; does the trick

(add-hook 'after-change-major-mode-hook
          (lambda()
            (when (not buffer-read-only)
              (setq show-trailing-whitespace t))))

(which-key-mode 1)

(show-paren-mode t)
(setq-default require-final-newline t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "a63355b90843b228925ce8b96f88c587087c3ee4f428838716505fd01cf741c8" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "015ed1c4e94502568b7c671ced6fe132bec9edf72fd732aa59780cfbe4b7927c" default))
 '(highlight-parentheses-colors '("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900"))
 '(lsp-eldoc-render-all t nil nil "Customized with use-package lsp-mode")
 '(lsp-idle-delay 0.6 nil nil "Customized with use-package lsp-mode")
 '(lsp-rust-analyzer-cargo-watch-command "clippy" nil nil "Customized with use-package lsp-mode")
 '(lsp-rust-analyzer-server-display-inlay-hints t nil nil "Customized with use-package lsp-mode")
 '(lsp-ui-doc-enable nil nil nil "Customized with use-package lsp-ui")
 '(lsp-ui-peek-always-show t nil nil "Customized with use-package lsp-ui")
 '(lsp-ui-sideline-show-hover t nil nil "Customized with use-package lsp-ui")
 '(package-selected-packages
   '(flycheck-kotlin kotlin-mode arduino-mode urlenc svelte-mode flycheck rust-mode rustic projectile yasnippet highlight-parentheses gradle-mode unicode-fonts spacemacs-theme intellij-theme alect-themes leuven-theme php-mode material-theme company lsp-ui lsp-mode flycheck-rust flymake-rust rust-playground which-key yaml-mode editorconfig json-mode haskell-mode win-switch use-package undo-tree solarized-theme smartparens slime scala-mode2 popup-switcher multi-web-mode mu4e-maildirs-extension markdown-preview-mode magit lua-mode intero hlinum helm-projectile groovy-mode grizzl graphviz-dot-mode gnuplot-mode geiser f erlang eproject ensime dockerfile-mode cider auto-highlight-symbol auto-complete))
 '(ps-font-size '(7 . 8))
 '(ps-header-font-size '(10 . 10))
 '(ps-header-title-font-size '(12 . 12))
 '(ps-paper-type 'a4)
 '(safe-local-variable-values '((erlang-ident-level . 2) (allout-layout . t))))

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

(setq message-log-max 2048)

;; mozrepl
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'javascript-mode-hook 'java-custom-setup)
(defun javascript-custom-setup ()
  (moz-minor-mode 1))
;; mozrepl end

(if (and window-system
         (version< emacs-version "26"))
    (global-linum-mode 1)
  (global-display-line-numbers-mode 1))

;; from https://github.com/nschum/highlight-parentheses.el.git
(my-load-use 'highlight-parentheses)
(add-to-hooks 'highlight-parentheses-mode
              'emacs-lisp-mode-hook
              'erlang-mode-hook
              'clojure-mode-hook
              'haskell-mode-hook
              'javascript-mode-hook)

(use-package ido
  :defer t)
(ido-mode t)
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

(use-package popup-switcher
  :defer t)
;; (setq psw-in-window-center t)
(global-set-key [f2] 'psw-switch-buffer)

(use-package desktop
  :defer t
  :config
  (add-to-list 'desktop-path "."))

(let ((elapsed (float-time (time-subtract (current-time)
                                          emacs-start-time))))
  (message "Loading %s...done (%.3fs)" load-file-name elapsed)

  (add-hook 'after-init-hook
            `(lambda ()
               (let ((elapsed (float-time (time-subtract (current-time)
                                                         emacs-start-time))))
                 (message "Loading %s...done (%.3fs) [after-init]"
                          ,load-file-name elapsed)))
            t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color)) (:underline "Red"))) t)
 '(flymake-warnline ((((class color)) (:underline "Orange"))) t)
 '(show-paren-match-face ((((class color)) (:background "lightblue" :foreground "black"))) t)
 '(show-paren-mismatch-face ((((class color)) (:background "purple" :foreground "white"))) t))

(setq mac-right-option-modifier nil
      ;;mac-command-key-is-meta t
      ;;mac-command-modifier 'meta
      ;;mac-option-modifier 'none
      )
