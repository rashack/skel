(add-to-list 'load-path "~/src/scala-mode")
(require 'scala-mode-auto)

(add-to-list 'load-path "~/src/ensime-server/ensime-server/elisp/")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
