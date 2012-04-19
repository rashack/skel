;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;  flymake config start ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ecj-flymake http://www.khelekore.org/~robo/ecj-flymake/
;;(add-to-list 'load-path "~/pkg/flymake/cvs")
(require 'flymake "~/.emacs.d/elisp/flymake.el")
(setq flymake-log-level 1) ; set this when debugging flymake
(setq flymake-compiler-jar "/home/kjean/src/ecj-flymake/jars/compiler.jar")

(global-set-key [f4] 'flymake-display-err-menu-for-current-line)
(global-set-key [f3] 'flymake-goto-next-error)

(custom-set-faces
 '(flymake-errline ((((class color)) (:underline "Red"))))
 '(flymake-warnline ((((class color)) (:underline "Orange")))))

(setq flymake-start-syntax-check-on-newline nil)

(setq flymake-no-changes-timeout nil)

(defun get-source-dirs (base-dir src-dir)
  (let (res)
    (dolist (p (split-string src-dir ":") res)
      (if res
	  (setq res (concat res ":" base-dir "/" p))
	(setq res (concat base-dir "/" p))))))

;; (get-source-dirs
;;  hercules-home
;;  "code/src:code/regressiontests")

(defun compile-server-dir-init (base-dir src-dir lib-dir)
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'java-ecj-create-temp-file))
	 (jar-files (files-in-below-directory-safe base-dir lib-dir))
	 (class-path (mapconcat 'identity jar-files ":"))
	 (command (format (concat "-Xemacs -1.6 -proceedOnError -proc:none "
				  "-warn:-serial -warn:+uselessTypeCheck,unnecessaryElse -warn:+over-ann "
				  "-sourcepath %s %s %s\n")
			  (get-source-dirs base-dir src-dir)
;;			  (get-source-dir base-dir src-dir)
			  (get-class-path-string class-path)
			  temp-file)))
    (list command)))

;; (defun compile-server-bios-init ()
;;   (compile-server-dir-init bios-home "src" "src/lib"))

;; (push (list (concat bios-home "/src.+\\.java$")
;; 	    'compile-server-bios-init
;; 	    'compile-server-flymake-cleanup)
;;       flymake-allowed-file-name-masks)

(set-variable 'hercules-home (concat (getenv "TD_SRC_HOME") "/hercules"))

(defun compile-hercules-init ()
  (compile-server-dir-init hercules-home "code/src" "lib"))

(push (list (concat hercules-home "/code/src.+\\.java$")
	    'compile-hercules-init
	    'compile-server-flymake-cleanup)
      flymake-allowed-file-name-masks)


(set-variable 'batch-home (concat (getenv "TD_TRUNK_SRC_HOME") "hercules-modules/batch"))
(defun compile-batch-init ()
  (compile-server-dir-init batch-home "code/src" "lib"))
(push (list (concat batch-home "/code/src.+\\.java$")
	    'compile-batch-init
	    'compile-server-flymake-cleanup)
      flymake-allowed-file-name-masks)


;; (setq flymake-allowed-file-name-masks (cdr flymake-allowed-file-name-masks))

(defun compile-hercules-regressiontests-init ()
  (compile-server-dir-init hercules-home "code/src:/code/regressiontests" "lib"))

(push (list (concat hercules-home "/code/\\(src\\|regressiontests\\).+\\.java$")
	    'compile-hercules-regressiontests-init
	    'compile-server-flymake-cleanup)
      flymake-allowed-file-name-masks)

(push '("\\(.*?\\):\\([0-9]+\\): error: \\(.*?\\)\n" 1 2 nil 2 3
	(6 compilation-error-face)) compilation-error-regexp-alist)

;; flymake "goto next erro on M-p..." (from fredrikm)
(defvar my-flymake-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\M-p" 'flymake-goto-prev-error)
    (define-key map "\M-n" 'flymake-goto-next-error)
    map)
  "Keymap for my flymake minor mode.")

(defun my-flymake-err-at (pos)
  (let ((overlays (overlays-at pos)))
    (remove nil
            (mapcar (lambda (overlay)
                      (and (overlay-get overlay 'flymake-overlay)
                           (overlay-get overlay 'help-echo)))
                    overlays))))

(defun my-flymake-err-echo ()
  (message "%s" (mapconcat 'identity (my-flymake-err-at (point)) "\n")))

(defadvice flymake-goto-next-error (after display-message activate compile)
  (my-flymake-err-echo))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  (my-flymake-err-echo))

(define-minor-mode my-flymake-minor-mode
  "Simple minor mode which adds some key bindings for moving to the next and previous errors.
Key bindings:
\\{my-flymake-minor-mode-map}"
  nil
  nil
  :keymap my-flymake-minor-mode-map)

;; rainbow-mode
;; (require 'highlight-parentheses)
;; (setq hl-paren-colors
;;         '("red" "yellow1" "greenyellow" "green1"
;;         "springgreen1" "cyan1" "slateblue1" "magenta1" "purple"))
;; seems to make everythi-ng slow
;; (add-hook 'highlight-parentheses-mode-hook
;;           '(lambda ()
;;              (setq autopair-handle-action-fns
;;                    (append
;;                                      (if autopair-handle-action-fns
;;                                              autopair-handle-action-fns
;;                                        '(autopair-default-handle-action))
;;                                      '((lambda (action pair pos-before)
;;                                              (hl-paren-color-update)))))))

;; end flymake "goto next erro on M-p..." (from fredrikm)
