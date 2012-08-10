(defun jdb-debug-applet ()
  (interactive)
  (dired (getenv "BIOS_HOME"))
  (jdb "jdb -sourcepathsrc -attach 8001"))
(global-set-key "\C-x\C-jd" 'jdb-debug-applet)

(defun jdb-debug-tomcat ()
  (interactive)
  (dired (getenv "BIOS_SRC_HOME"))
  (jdb "jdb -attach 8000"))
;; debugging jboss below instead
;;(global-set-key "\C-x\C-jt" 'jdb-debug-tomcat)

;; (defun jdb-debug-jboss (src-path)
;;   (interactive "fEnter source path: ")
;;   (dired src-path)
;;   (jdb (concat "jdb -attach 5005" "-sourcepath" (concat src-path "/com/tradedoubler/pan/mbeans/configreader"))))
;; (global-set-key "\C-x\C-jj" 'jdb-debug-jboss)

(defvar pan-sourcepath (concat "/home/kjean/src/td/oracle_upgrade-git/pan/src/ejb/src/main/java:"
			       "/home/kjean/src/td/oracle_upgrade-git/pan/src/common/src/main/java:"
			       "/home/kjean/src/td/oracle_upgrade-git/pan/src/webapp-pan/src/main/java"))
(defvar commons-sourcepath "/home/kjean/src/td/trunk/commons/src/main/java/")
(defvar test-sourcepath (concat "pan/src/ejb3/src/main/"))
(defun jdb-debug-test ()
  (interactive)
  (dired "/home/kjean/src/td/trunk/")
  (jdb (concat "jdb -attach 5111 -sourcepath" test-sourcepath)))
(global-set-key "\C-x\C-jt" 'jdb-debug-test)
;;"MAVEN_OPTS="-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5111"

(defun jdb-debug-commons ()
  (interactive)
  (jdb (concat "jdb -connect com.sun.jdi.SocketAttach:hostname=localhost,port=16384 -sourcepath" commons-sourcepath)))
(global-set-key "\C-x\C-jc" 'jdb-debug-commons)

;;(defmacro jdb-debug (name port src-path key-binding)
;; (defmacro jdb-debug (name port src-path)
;;   `(defun ,name ()
;;      (interactive)
;;      (jdb (concat "jdb -attach " ,port "-sourcepath" ,src-path))))
;;  (global-set-key key-binding name))

;;(macroexpand '
;; (jdb-debug 'jdb-debug-commons "5112" commons-sourcepath)  ;; "\C-x\C-jq"))
(defvar hercules-sourcepath (concat (getenv "HERCULES_SRC_HOME") "/code/src"))
(defun jdb-debug-hercules ()
  (interactive)
;;  (jdb (concat "jdb -attach 8642 -sourcepath" hercules-sourcepath)))
  (jdb (concat "jdb -connect com.sun.jdi.SocketAttach:hostname=localhost,port=8642 -sourcepath" hercules-sourcepath)))
(global-set-key "\C-x\C-jh" 'jdb-debug-hercules)


(defvar pf-sourcepath (concat (getenv "TD_SRC_HOME") "/athena/src/importer"))
(defun jdb-debug-pf ()
  (interactive)
  (let ((conn-string (concat "jdb -connect com.sun.jdi.SocketAttach:hostname=localhost,port=5555 -sourcepath"
			     pf-sourcepath)))
    (message "%s" conn-string)
    (jdb conn-string)))
(global-set-key "\C-x\C-jp" 'jdb-debug-pf)


(setq max-specpdl-size 5)
(setq debug-on-error t)

(defun jdb-debug-jboss ()
  (interactive)
  (jdb (concat "jdb -attach 5005 -sourcepath" pan-sourcepath)))
(global-set-key "\C-x\C-jj" 'jdb-debug-jboss)


;; (setenv "GTAGSLIBPATH" (mapconcat 'identity (mapcar 'getenv
;; 						   '("HERCULES_SRC_HOME"
;; 						     "HERCULES_MODULES_SRC_HOME"
;; 						     "TD_TRUNK_SRC_HOME"))
;; 				 ":"))
