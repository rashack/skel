(use-package projectile
  :ensure projectile)

(add-hook 'clojure-mode-hook 'projectile-mode)
(add-hook 'haskell-mode-hook 'projectile-mode)
(add-hook 'java-mode-hook 'projectile-mode)
(add-hook 'ruby-mode-hook 'projectile-mode)
