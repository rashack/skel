(add-to-list 'load-path (elisp-root "scala-mode"))
(use-package scala-mode-auto
  :init
  (progn
    (add-to-list 'load-path "~/src/ensime-server/ensime-server/elisp/")
    (use-package ensime
      :init
      (add-hook 'scala-mode-hook 'ensime-scala-mode-hook))))
