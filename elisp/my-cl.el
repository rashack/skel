(use-package slime
  :ensure slime
  :init
  (progn
    (setq inferior-lisp-program "/usr/bin/sbcl")
    (slime-setup)))
