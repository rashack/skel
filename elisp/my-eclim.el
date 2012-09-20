(add-to-list 'load-path (expand-file-name (concat (getenv "HOME") "/src/emacs-eclim/")))
;; only add the vendor path when you want to use the libraries provided with emacs-eclim
(add-to-list 'load-path (expand-file-name "~/coding/git/emacs-eclim/vendor"))
(require 'eclim)

(setq eclim-auto-save t)
(global-eclim-mode)

(setq eclim-executable (concat (getenv "HOME") "/eclipse/eclim"))

(require 'eclimd)
