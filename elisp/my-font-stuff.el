(defvar my-font-size 0)

(defconst my-font-fixed "-misc-fixed-medium-r-semicondensed-*-13-120-75-75-c-60-iso8859-*")
;; (print (font-family-list))
;; "Droid Sans Mono-10"
;; "DejaVu Sans Mono-10"
;; "Liberation Mono-10"
;; "Inconsolata-9"
(defconst my-font-scaled "Inconsolata-9")

(defun my-font-set (font)
  (set-frame-font font nil t))

(defun my-font-message (font size)
  (message (format "Font: %s size: %d" font size)))

(defun my-font-inc ()
  (interactive)
  (when (= my-font-size 0)
    (my-font-set my-font-scaled))
  (text-scale-increase 1)
  (setq my-font-size (+ my-font-size 1))
  (my-font-message my-font-scaled my-font-size))

(defun my-font-dec ()
  (interactive)
  (cond ((= my-font-size 1)
         (progn (setq my-font-size 0)
                (text-scale-increase 0)
                (my-font-set my-font-fixed)
                (my-font-message my-font-fixed my-font-size)))
        ((= my-font-size 0)
         (progn (my-font-message my-font-scaled my-font-size)))
        (t
         (progn (setq my-font-size (- my-font-size 1))
                (text-scale-increase -1)
                (my-font-message my-font-scaled my-font-size)))))

(global-set-key (kbd "C-x C-+") 'my-font-inc)
(global-set-key (kbd "C-x C--") 'my-font-dec)
