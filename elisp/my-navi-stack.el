(defvar navi-stack-buffer (generate-new-buffer "*Navi-Stack*"))

(defvar navi-stack-stack '())

(defun navi-stack-update-buffer ()
  (interactive)
  (with-current-buffer (get-buffer-create navi-stack-buffer)
    (mark-whole-buffer)
    (delete-region (region-beginning) (region-end))
    (mapcar 'insert (reverse navi-stack-stack))))

(defun navi-stack-in ()
  (interactive)
  (let ((stack-entry (format "* %s:%s\n%s\n"
                             (buffer-file-name)
                             (line-number-at-pos)
                             (buffer-substring (line-beginning-position) (line-end-position)))))
    (push stack-entry navi-stack-stack))
    (navi-stack-update-buffer))

(defun navi-stack-out ()
  (interactive)
  (pop navi-stack-stack)
  (navi-stack-update-buffer))

(defun navi-stack-wrap-and-bind-in (keymap key def)
  (define-key keymap key (lambda ()
                           (navi-stack-in)
                           (def))))

(defun navi-stack-wrap-and-bind-out (keymap key def)
  (define-key keymap key (lambda ()
                           (navi-stack-out)
                           (def))))

