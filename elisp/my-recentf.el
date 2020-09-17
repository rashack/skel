(use-package recentf
  :defer t)
(recentf-mode 1)

(defvar closed-files (list))

(defun track-closed-file ()
  (and buffer-file-name
       (message buffer-file-name)
       (or (delete buffer-file-name closed-files) t)
       (add-to-list 'closed-files buffer-file-name)))

(defun last-closed-files ()
  (interactive)
  (find-file (ido-completing-read "Last closed: " closed-files)))

(add-hook 'kill-buffer-hook 'track-closed-file)

;;(define-prefix-command 'recent-files-map)
;;(global-set-key "\C-xr" 'recent-files-map)
;;(define-key recent-files-map "r" 'recentf-open-files)
;;(define-key recent-files-map "c" 'last-closed-files)
