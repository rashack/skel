(prefer-coding-system 'utf-8-unix)

;; Load my-ediff-setup from file my-ediff-util.el when needed.
(autoload 'my-ediff-setup "my-ediff-util" "Fix ediff annoyances" nil)

(defun my-command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
	(file2 (pop command-line-args-left)))
    (progn
      ;;      (my-ediff-setup nil) ;; uncomment to setup ediff customizations
      (ediff file1 file2))))
(add-to-list 'command-switch-alist '("--diff" . my-command-line-diff))

;; EDI-mode
(autoload 'edi-mode "edi-mode" "Edit EDI" t)
(add-to-list 'auto-mode-alist '("\\.edi\\'" . edi-mode))

(defun my-utf8-shell ()
  (interactive)
  (progn (shell)
         (set-buffer-process-coding-system 'utf-8 'utf-8)
         (insert "set LANG=en_US.utf8 && set HGENCODING=utf8")
         (comint-send-input nil t)))

(defun yfindf (regex &optional search-comments)
  "Search all APL code in trunk for a given regular expression.
 With a prefix argument, hits inside comment lines are returned as well."
  (interactive "sRegex:\nP")
  (let* ((default-directory "c:/repo/tc-130611/")
         (search (concat"grep -inEH -e \"" regex "\" *.apl"))
         (command (if search-comments
                      search
                    (concat search
                            " | grep -iEv -e \"^[^:]+:[0-9]+: *⍝.+$\""))))
    (compilation-start command 'grep-mode)))
