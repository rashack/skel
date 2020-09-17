(use-package toml-mode
  :defer t)

(use-package rust-mode
  :defer t
  :hook (rust-mode . lsp))

;; Add keybindings for interacting with Cargo
(use-package cargo
  :defer t
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust
  :defer t
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
