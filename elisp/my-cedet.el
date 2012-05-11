;;(require 'cedet "~/src/cedet/common/cedet.el")
(load-file "~/src/cedet/common/cedet.el")
(require 'cedet-java)
(global-ede-mode t)                      ; Enable the Project management system

(require 'semanticdb)
(when (cedet-gnu-global-version-check t)
  (require 'semanticdb-global)
  (semanticdb-enable-gnu-global-databases 'java-mode))
(require 'semantic-ia)
(require 'semantic-java)

;;(semantic-load-enable-minimum-features)  ; * This enables the database and idle reparse engines
(semantic-load-enable-code-helpers)      ; * Enable prototype help and smart completion
;(semantic-load-enable-gaudy-code-helpers)
(semantic-load-enable-excessive-code-helpers)
;;(global-srecode-minor-mode 1)            ; Enable template insertion menu
(semanticdb-enable-gnu-global-databases 'java-mode)
(semantic-load-enable-semantic-debugging-helpers)
(setq semanticdb-default-save-directory "~/.emacs.d/semantic.cache")

; jde stuff
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/jde"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/speedbar"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/semantic"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/elib"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/eieio"))
;(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-lisp/cedet-common"))
;(load-file (expand-file-name "/usr/share/emacs/site-lisp/cedet-common/cedet.el"))
;(require 'jde)

(defun find-jars-in-dir (dir &optional recursive)
  (if recursive
      '()
    (directory-files dir t ".*.jar")))

;;(length (directory-files-and-attributes hercules-lib-dir t))

(defun hercules-lib-dir
  (concat (getenv "HERCULES_SRC_HOME") "/lib"))
(defun set-hercules-semanticdb-javap-classpath
  (setq semanticdb-javap-classpath (find-jars-in-dir (hercules-lib-dir))))

(add-hook 'java-mode-hook 'flymake-mode)
(add-hook 'java-mode-hook 'my-flymake-minor-mode)
(add-hook 'java-mode-hook 'gtags-mode)
(add-hook 'java-mode-hook
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (c-set-offset 'func-decl-cont 0)
	     (fix-java-annotation-indentation-frema)
	     (semantic-add-system-include (getenv "JAVA_HOME") 'java-mode)
	     (semantic-add-system-include (concat (getenv "HERCULES_SRC_HOME") "/code/src") 'java-mode)
	     (set-hercules-semanticdb-javap-classpath)))
