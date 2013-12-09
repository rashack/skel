(add-to-list 'load-path "/usr/share/emacs/site-lisp/erlang")

(use-package erlang-start)
(add-to-list 'load-path (elisp-root "edts"))
(use-package edts-start
  :init
  (progn
    (edts-log-set-level 'debug)
    (add-hook 'erlang-mode-hook
              (lambda ()
                (setq-local whitespace-style '(face lines-tail))
                (setq-local whitespace-line-column 80)
                (whitespace-mode t)))))
