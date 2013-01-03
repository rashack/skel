(add-hook 'java-mode-hook 'flymake-mode)
(add-hook 'java-mode-hook 'my-flymake-minor-mode)
(add-hook 'java-mode-hook 'gtags-mode)
(add-hook 'java-mode-hook
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (setq tab-width 4)
	     (c-set-offset 'func-decl-cont 0)
	     (fix-java-annotation-indentation-frema)))

;;(load-library "my-cedet.el")
