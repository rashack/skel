(add-to-list 'load-path "~/src/haskell-mode/")
(use-package haskell-mode-autoloads
  :init
  (progn
    (add-to-list 'Info-default-directory-list "~/lib/emacs/haskell-mode/")
    (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
    (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
    ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
    ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
))
