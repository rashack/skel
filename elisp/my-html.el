;; from https://github.com/fgallina/multi-web-mode.git
(add-to-list 'load-path (elisp-root "multi-web-mode"))
(use-package multi-web-mode
  :init
  (progn
    (setq mweb-default-major-mode 'html-mode)
    (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
		      (js-mode "<script[^>]*>" "</script>")
		      (css-mode "<style[^>]*>" "</style>")))
    (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
    (multi-web-global-mode 1)))
