(use-package clojure-mode
  :ensure clojure-mode)

(use-package cider
  :ensure cider)
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file (expand-file-name "cider-repl-history" my-emacs-dir))
