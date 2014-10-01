(add-to-list 'load-path (elisp-root "clojure-mode"))
(use-package clojure-mode)

;; required by cider
(ensure-package-installed 'queue)
(add-to-list 'load-path (expand-file-name "elpa/queue-0.1.1" my-emacs-dir))

(my-load-use 'cider)
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file (expand-file-name "cider-repl-history" my-emacs-dir))
