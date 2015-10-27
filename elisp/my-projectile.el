(use-package projectile
  :ensure projectile)

(eval-after-load 'projectile-mode
  '(define-key projectile-command-map (kbd "C-x f") 'projectile-find-file))

(projectile-global-mode)
(setq projectile-completion-system 'grizzl)
