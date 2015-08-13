(add-to-list 'load-path (elisp-root "scala-mode"))
(use-package scala-mode2
  :ensure scala-mode2
  :init
  (progn
    (add-to-list 'load-path "~/src/ensime-server/ensime-server/elisp/")
    (use-package ensime
      :ensure ensime
      :init
      (add-hook 'scala-mode-hook 'ensime-scala-mode-hook))))
