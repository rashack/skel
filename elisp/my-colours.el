(add-to-list 'custom-theme-load-path (elisp-root "emacs-color-theme-solarized"))
(add-to-list 'custom-theme-load-path (elisp-root "zenburn-emacs"))

(defun my-colours-set ()
  (interactive)
  (set-background-color "grey15")
  (set-foreground-color '"grey75")
  (set-cursor-color "red"))

(defun my-colours-disable-all-themes ()
  (interactive)
  (mapc (lambda (theme) (disable-theme theme))
        custom-enabled-themes))

(defun my-colours-theme (theme)
  (interactive
   (list (intern (completing-read
                  "Set custom theme: "
                  '(("solarized-dark" 1) ("solarized-light" 2) ("zenburn" 3)
                    ("default" 4) ("my-solarized" 5))
                  nil t))))
    (my-colours-disable-all-themes)
    (cond ((eq theme 'default)
           (my-colours-set))
          ((eq theme 'my-solarized)
           (load-theme 'solarized-dark t)
           (my-colours-set))
          (t
           (load-theme theme t nil))))

;; Some new Colors for Font-lock.
(setq font-lock-mode-normal-decoration t)
(require 'font-lock)

(setq default-frame-alist
      '(
        (cursor-color . "red")
        (cursor-type . box)
        (foreground-color . "gray")
        (background-color . "black")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flymake-errline ((((class color)) (:underline "Red"))))
 '(flymake-warnline ((((class color)) (:underline "Orange"))))
 '(show-paren-match-face ((((class color)) (:background "lightblue" :foreground "black"))) t)
 '(show-paren-mismatch-face ((((class color)) (:background "purple" :foreground "white"))) t))
;(set-face-background 'region "mediumpurple4")
(set-face-background 'trailing-whitespace "navy")

;; ;; Turn on colorization
(global-font-lock-mode t)

(when window-system
  (global-hl-line-mode 1)
  (set-face-background 'hl-line "#222"))
