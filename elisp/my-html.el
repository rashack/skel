;; from https://github.com/fgallina/multi-web-mode.git
(use-package multi-web-mode
  :defer t
  :ensure multi-web-mode
  :init
  (progn
    (setq mweb-default-major-mode 'html-mode)
    (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
		      (js-mode "<script[^>]*>" "</script>")
		      (css-mode "<style[^>]*>" "</style>")))
    (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
    (multi-web-global-mode 1)))
