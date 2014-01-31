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
                (whitespace-mode t)
                (linum-mode)))))

(defconst erl-mfa-regexp
  ;; Match      <module>,  <fun>,       <arity>,  [{file
  ;; Groups   1:<module> 3:<function> 5:<arity> 6:[{file
  "\\(\\(\\sw\\|\\s_\\)+\\),\\s *\\(\\(\\sw\\|\\s_\\)+\\),\\s *\\([0-9]\\),\\s *\\(\\[{file\\)")

(defun erl-trace (start end)
  "Try to convert an Erlang stack trace [in buffer] to something a little more readable."
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      ;; rewrite "<module>, <function>, <arity>, [{file" to "<module>:<function>/<arity>, [{file"
      (replace-regexp erl-mfa-regexp
                      "\\1:\\3/\\5, \\6" nil (point-min) (point-max))
      ;; rewrite "[{file, "<file>"}, {line, <line>}]" to "<file>:<line>"
      (replace-regexp erl-location-regexp
                      "\"\\1:\\2\"" nil (point-min) (point-max))
      (align-regexp (point-min) (point-max) ".*\\(, +\\).*" 1 2 t))))

(defconst erl-location-regexp
  ;; Matches  [{file, "some/dir/module.erl"}, {line, 13}}]
  ;; Match    [{file, "<file>"}, {line, <line>}]
  ;; Groups          1:<file>         2:<line>
  "\\[{file,\\s *\"\\([^\"]*\\)\"},\\s *{line,\\s *\\([0-9]+\\)}\\]")

(defun erl-stack (start end)
  "Try to extract an Erlang stack trace from the region, copy it, format it
in an Emacs-friendly way and put it in a buffer."
  (interactive "*r")
  (let ((buf (generate-new-buffer "erlang-stack-trace")))
    (save-excursion
      (save-restriction
        (narrow-to-region start end)
        (beginning-of-buffer)
        (while (condition-case nil
                   ;; condition-case becase I can't get re-search-forward to exit cleanly
                   (re-search-forward erl-location-regexp)
                 (error nil))
          (let ((file (match-string 1))
                (line (match-string 2)))
            (with-current-buffer buf
              (insert file ":" line "\n")
              (erlang-mode))))))
    (switch-to-buffer buf)))

(defun erl-align (start end)
  "Align around commas to try to make hairy lists of records readable."
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (align-regexp (point-min) (point-max)  "\\(, *\\)" 1 2 t)
      (delete-trailing-whitespace))))
