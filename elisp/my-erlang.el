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

(defun erl-trace (start end)
  "Try to convert an Erlang stack trace to something a little more readable."
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      ;; rewrite "<module>, <function>, <arity>, [{file" to "<module>:<function>/<arity>, [{file"
      (replace-regexp "\\(\\(\\sw\\|\\s_\\)+\\),[ \t\n]*\\(\\(\\sw\\|\\s_\\)+\\),[ \t\n]*\\([0-9]\\),[ \t\n]*\\(\\[{file\\)"
                      "\\1:\\3/\\5, \\6" nil (point-min) (point-max))
      ;; rewrite "[{file, "<file>"}, {line, <line>}]" to "<file>:<line>"
      (replace-regexp "\\[{file,[ \t\n]*\"\\([^\"]*\\)\"},[ \t\n]*{line,[ \t\n]*\\([0-9]+\\)}\\]"
                      "\"\\1:\\2\"" nil (point-min) (point-max))
      (align-regexp (point-min) (point-max) ".*\\(, +\\).*" 1 2 t))))

(defun erl-align (start end)
  "Align around commas to try to make hairy lists of records readable."
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (align-regexp (point-min) (point-max)  "\\(, *\\)" 1 2 t)
      (delete-trailing-whitespace))))
