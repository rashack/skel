(require 'vc-svn)
;;(require 'psvn)
(require 'csv-mode)

;; At least vc-diff for mercurial seems to need this for proper colouring.
(add-hook 'diff-mode-hook
          '(lambda ()
             (require 'ansi-color)
             (ansi-color-apply-on-region (point-min) (point-max))))
