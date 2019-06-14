(defun kf-create-load-order-module ()
  (interactive)
  (let* ((branch (git-branch))
         (repo-root (capture-shell-command-output "git rev-parse --show-toplevel"))
         (user-name (capture-shell-command-output "git config user.name"))
         (user-email (capture-shell-command-output "git config user.email"))
         (module-name (concat branch "_UP"))
         (file-name (concat repo-root "/lib/upgrade/src/" module-name ".erl")))
    (message "branch: %s root: %s" branch repo-root)
    (find-file file-name)
    (insert-file (concat (getenv "HOME") "/src/klarna/slask/kjell/elisp/load_order_template.erl"))
    (save-excursion
      (save-restriction
        (replace-regexp "load_order_template" (concat "'" module-name "'") nil)
        (replace-regexp "<branch-name>" branch nil)
        (replace-regexp "<user-name>" user-name nil)
        (replace-regexp "<user-email>" user-email nil)))))

(defun kf-cc-to-macro (start end)
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (dolist (m kf-cc-to-macro)
        (let ((from (car m))
              (to   (cdr m)))
          (replace-regexp from to nil start end))))))


(defconst kf-cc-to-macro
  '(( "\\(^\\|[^0-9]\\)15\\([^0-9]\\|$\\)" . "\\1\?ISO3166_CC_AT\\2")
    ( "\\(^\\|[^0-9]\\)59\\([^0-9]\\|$\\)" . "\\1\?ISO3166_CC_DK\\2")
    ( "\\(^\\|[^0-9]\\)73\\([^0-9]\\|$\\)" . "\\1\?ISO3166_CC_FI\\2")
    ( "\\(^\\|[^0-9]\\)81\\([^0-9]\\|$\\)" . "\\1\?ISO3166_CC_DE\\2")
    ("\\(^\\|[^0-9]\\)154\\([^0-9]\\|$\\)" . "\\1\?ISO3166_CC_NL\\2")
    ("\\(^\\|[^0-9]\\)164\\([^0-9]\\|$\\)" . "\\1\?ISO3166_CC_NO\\2")
    ("\\(^\\|[^0-9]\\)209\\([^0-9]\\|$\\)" . "\\1\?ISO3166_CC_SE\\2")))

(defun kf-cc2macro-regex ()
  (interactive)
  (message
  (mapcar (lambda (m)
              (cons (concat "\\(^\\|[^0-9]\\)" (car m) "\\([^0-9]\\|$\\)")
                    (concat "\\1" (cdr m) "\\2")))
          kf-cc2macro-mapping)))

(defun kf-macro2cc-regex ()
  (interactive)
  (message
  (mapcar (lambda (m)
            (cons (concat "\\(^\\|[^?]\\)" (car m) "\\([^0-9a-zA-Z_]\\|$\\)")
                  (concat "\\1" (cdr m) "\\2")))
          (kerl-flip-pairs kf-cc2macro-mapping))))

(defconst kf-cc2macro-mapping
  '(( "15" . "?ISO3166_CC_AT")
    ( "59" . "?ISO3166_CC_DK")
    ( "73" . "?ISO3166_CC_FI")
    ( "81" . "?ISO3166_CC_DE")
    ("154" . "?ISO3166_CC_NL")
    ("164" . "?ISO3166_CC_NO")
    ("209" . "?ISO3166_CC_SE")))

(defconst kf-klarna-online "https://online.int.klarna.net")

(defun kf-open-kcase ()
  (interactive)
  (message (format "start %s" (real-this-command)))
  (let* ((browse-url-firefox-program "/usr/local/firefox/firefox")
         (default-cid (thing-at-point 'symbol))
         (cid (read-string "Open kcase in KO, cid: " default-cid))
         (url (format "%s/case_show.yaws?cid=%s" klarna-online cid)))
    (browse-url-firefox url)))

(defun kf-open-inv ()
  (interactive)
  (message (format "start %s" (real-this-command)))
  (let* ((browse-url-firefox-program "/usr/local/firefox/firefox")
         (default-cid (thing-at-point 'symbol))
         (cid (read-string "Open invoice in KO, invno: " default-cid))
         (url (format "%s/invoice_show.yaws?invno=%s" klarna-online cid)))
    (browse-url-firefox url)))
