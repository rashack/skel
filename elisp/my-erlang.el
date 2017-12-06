;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/erlang")
(add-to-list 'load-path (concat (getenv "ERLANG_HOME") "/elisp"))
(add-to-list 'load-path "/home/kjell/src/edts/")

(defun my-erlang-mode-hook ()
  (set-face-attribute 'erlang-font-lock-exported-function-name-face nil
                      :inherit font-lock-function-name-face
                      :underline t)
  (setq-local whitespace-style '(face lines-tail))
  (setq-local whitespace-line-column 80)
  (whitespace-mode t)
  ;;(setq erlang-electric-commands (remove 'erlang-electric-gt erlang-electric-commands))
  ;;(yas-minor-mode)
  (message " *** my-erlang-mode-hook")
  (edts-mode)
  ;;(navi-stack-wrap-and-bind-in edts-mode-map "M-." 'edts-find-source-under-point)
  ;;(navi-stack-wrap-and-bind-out edts-mode-map "M-," 'edts-find-source-unwind)
  ;;(local-set-key (kbd "C-c C-c") #'merl-comment-region)
)

(setq edts-inhibit-package-check t)
(require 'edts-start)

(use-package edts-start
  :defer t
  ;;  :ensure edts
  :init
  (message "*** init edts-start")
  (add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
  :config
  (message "*** config edts-start")
  (edts-log-set-level 'debug))

(defconst merl-mfa-regexp
  ;; Match      <module>,  <fun>,       <arity>,  [{file
  ;; Groups   1:<module> 3:<function> 5:<arity> 6:[{file
  "\\(\\(\\sw\\|\\s_\\)+\\),\\s *\\(\\(\\sw\\|\\s_\\)+\\),\\s *\\([0-9]\\),\\s *\\(\\[{file\\)")

(defun merl-trace (start end)
  "Try to convert an Erlang stack trace [in buffer] to something a little more readable."
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      ;; rewrite "<module>, <function>, <arity>, [{file" to "<module>:<function>/<arity>, [{file"
      (replace-regexp merl-mfa-regexp
                      "\\1:\\3/\\5, \\6" nil (point-min) (point-max))
      ;; rewrite "[{file, "<file>"}, {line, <line>}]" to "<file>:<line>"
      (replace-regexp merl-location-regexp
                      "\"\\1:\\2\"" nil (point-min) (point-max))
      (align-regexp (point-min) (point-max) ".*\\(, +\\).*" 1 2 t))))

(defconst merl-location-regexp
  ;; Matches  [{file, "some/dir/module.erl"}, {line, 13}}]
  ;; Match    [{file, "<file>"}, {line, <line>}]
  ;; Groups          1:<file>         2:<line>
  "\\[{file,\\s *\"\\([^\"]*\\)\"},\\s *{line,\\s *\\([0-9]+\\)}\\]")

(defun merl-stack (start end)
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
                   (re-search-forward merl-location-regexp)
                 (error nil))
          (let ((file (match-string 1))
                (line (match-string 2)))
            (with-current-buffer buf
              (insert file ":" line "\n")
              (erlang-mode))))))
    (switch-to-buffer buf)))

(defun merl-align (start end)
  "Align around commas to try to make hairy lists of records readable."
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (align-regexp (point-min) (point-max) "\\(, *\\)" 1 2 t)
      (delete-trailing-whitespace))))

(defun merl-ang-skeleton ()
  (interactive)
  (insert (concat
           "-module().\n"
           "\n"
           "-export([]).\n"
           "\n"
           "%%% Local Variables:\n"
           "%%% erlang-indent-level: 2\n"
           "%%% End:\n")))

(defun merl-rename-var ()
  "Rename a variable, either in the active region or the present Erlang function clause."
  (interactive)
  (let* ((suggestion (if (use-region-p) "" (symbol-name (symbol-at-point))))
         (old-var-name (read-string "Variable name to change: " suggestion))
         (new-var-name (read-string (format "Change variable '%s' to : " old-var-name))))
    (if (use-region-p)
        (replace-regexp old-var-name new-var-name t (region-beginning) (region-end))
      (save-excursion
        (save-restriction
          (erlang-mark-clause)
          (replace-regexp old-var-name new-var-name t (region-beginning) (region-end)))))))

(defun merl-move-arrow (line column)
  "Move the arrow on line LINE to column COLUMN"
  (goto-char (point-min))
  (forward-line (1- line))
  (end-of-line)
  (search-backward "->")
  (insert (make-string (- column (current-column)) ? )))

(defun merl-align-arrows ()
  (interactive)
  (save-excursion
    (save-restriction
      (let ((end (progn (erlang-end-of-function) (point)))
            (beg (progn (erlang-beginning-of-function) (point)))
            (max-col 0)
            (arrows ()))
        ;; narrow to present function
        (narrow-to-region beg end)
        ;; find the column of the arrow on the longest line
        (while (search-forward "->" nil t)
          (progn (setq max-col (max max-col (current-column)))
                 (setq arrows (cons (line-number-at-pos) arrows))
                 (erlang-end-of-clause)))
        (message "%S" arrows)
        (erlang-beginning-of-function)
        (dolist (line arrows)
          (merl-move-arrow line (- max-col 2)))))))

(defun merl-mfa (str)
  (string-match "\\([a-zA-Z0-0_]\\):\\([a-zA-Z0-0_]\\)/\\([0-9]+\\)" str)
  (let ((res (list (match-string 1)
                   (match-string 2)
                   (string-to-int (match-string 3)))))
    (message "Jumpung to: %S" res)
    res))

(defun merl-find-source (str)
  (apply 'edts-find-source (merl-mfa str)))

(defun merl-edts-find-source-other-window ()
  (interactive)
  (cond
   ((edts-header-under-point-p) (let ((what (read-string (format "Jump to header '%S' or M:F/A "
                                                                 (edts-header-at-point)))))
                                  (if (string= "" what)
                                      (edts-find-header-source)
                                    (merl-find-source what))))
   ((edts-macro-under-point-p) (let ((what (read-string (format "Jump to macro '%S' or M:F/A "
                                                                (symbol-at-point)))))
                                 (if (string= "" what)
                                     (edts-find-macro-source)
                                    (merl-find-source what))))
   ((edts-record-under-point-p) (let ((what (read-string (format "Jump to record '%S' or M:F/A "
                                                                 (symbol-at-point)))))
                                  (if (string= "" what)
                                      (edts-find-record-source)
                                    (merl-find-source what))))
   ;;((edts-behaviour-under-point-p) (edts-find-behaviour-source))
   ((edts-mfa-at (point)) (let ((what (read-string (format "Jump to function '%S' or M:F/A "
                                                           (edts-mfa-at (point))))))
                            (if (string= "" what)
                                (apply #'edts-find-source (edts-mfa-at (point)))
                              (merl-find-source what))))
   (t (message "Nothing to do"))))

(defun merl-align-proplist (start end)
  "Align a property list properly."
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (align-regexp (point-min) (point-max) "[[\"?a-zA-Z]" 1 2 t))))

;; (defun erlang-path (&optional dirs)
;;   (let ((root "/kred/erlang/R15B03-1/install"))
;;     (expand-file-name (cond ((null dirs)    root)
;;                             ((consp dirs)   (mapconcat 'concat dirs "/"))
;;                             ((stringp dirs) (concat root "/" dirs)))
;;                       root)))

(defun merl-comment-region (start end)
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (comment-region start end)
      (replace-regexp "^  " "" nil (point-min) (point-max)))))

(defun merl-whitespace-fix (start end)
  "Untabify, indent, fix some comments"
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (delete-trailing-whitespace (point-min) (point-max))
      (untabify (point-min) (point-max))
      (replace-regexp "^% " "%% " nil (point-min) (point-max))
      (replace-regexp "^%\\([^%]\\)" "%% \\1" nil (point-min) (point-max))
      (replace-regexp "^ \+% " "%% " nil (point-min) (point-max))
      (replace-regexp "^ \+%\\([^%]\\)" "%% \\1" nil (point-min) (point-max))
      (replace-regexp "^ \+%
" "%%" nil (point-min) (point-max))
      (indent-region (point-min) (point-max)))))

(defun redbug ()
  "Send a redbug stop and start 'M:F->return' to the local EDTS node,
 for the M:F at point"
  (interactive "")
  (save-excursion
    (cl-flet ((erl-call-str (mfa-str)
                            (format "erl_call -n %s -a '%s'"
                                    (edts-api-node-name)
                                    mfa-str)))
      (let* ((mfa (edts-mfa-at (point)))
             (stop-call (erl-call-str "redbug, stop, []"))
             (start-call (erl-call-str
                          (format "redbug start [50000, 50000, \"%s:%s->return\"]"
                                  (first mfa)
                                  (second mfa)))))
        (shell-command stop-call)
        (shell-command start-call)))))
