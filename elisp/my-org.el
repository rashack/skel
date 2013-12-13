(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-co" 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/notes.org" "Tasks")
         "* TODO %?\n  %i%T\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i%T\n  %a")))
