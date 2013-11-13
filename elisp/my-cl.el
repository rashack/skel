(add-to-list 'load-path "/usr/share/common-lisp/source/slime/")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
(use-package slime
  :init
  (progn
    (setq inferior-lisp-program "/usr/bin/sbcl")
    (slime-setup)))
