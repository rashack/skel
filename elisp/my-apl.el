;;(set-frame-font "APL385 Unicode 10")

;; Dyalog-mode, from https://bitbucket.org/harsman/dyalog-mode
(add-to-list 'load-path (elisp-root "dyalog-mode"))
(use-package dyalog-mode
  :defer t
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.apl\\'" . dyalog-mode))
    (add-to-list 'auto-mode-alist '("\\.dyalog$" . dyalog-mode))
    (add-to-list 'file-coding-system-alist '("\\.apl\\'" . utf-8))
    (add-to-list 'file-coding-system-alist '("\\.dyalog\\'" . utf-8))
    ;; Make fill-paragraph work only in comment blocks and respect
    ;; Profdoc doc comments.
    (defvar profdoc-doc-comment
      "\\(ret\\|rarg\\|larg\\|author\\|see\\|docs\\|group\\|ex\\)")
    (add-hook 'dyalog-mode-hook
              '(lambda ()
                 (setq paragraph-start
                       (concat "^\\s-*⍝\\s-*\\\\" profdoc-doc-comment ".*$"))
                 (setq tab-width 4)
                 (which-func-mode t)))
    (autoload 'dyalog-ediff-forward-word "dyalog-mode" "Dyalog mode" t)
    (setq ediff-forward-word-function 'dyalog-ediff-forward-word)))
