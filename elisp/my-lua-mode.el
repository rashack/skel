(add-to-list 'load-path (elisp-root "lua-mode"))
(use-package lua-mode
  :init
  (progn
    ;; (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
    (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
    (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))))
