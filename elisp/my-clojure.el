;; from https://github.com/technomancy/clojure-mode.git

(add-to-list 'load-path (elisp-root "clojure-mode"))
(use-package clojure-mode)

(add-to-list 'load-path (expand-file-name "elpa/queue-0.1.1" my-emacs-dir))
(require 'queue)
(my-load-use 'cider)
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file (expand-file-name "cider-repl-history" my-emacs-dir))
