(use-package clojure-mode
  :defer t
  :ensure clojure-mode)

(use-package cider
  :defer t
  :ensure cider)
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file (expand-file-name "cider-repl-history" my-emacs-dir))
