;;(add-to-list 'load-path "~/src/mu/mu4e")
(use-package mu4e-maildirs-extension
  :defer t
  :ensure mu4e-maildirs-extension
  :init
  (progn
    (setq mu4e-maildir (home-root "/Mail"))
    ;; smtp mail setting; these are the same that `gnus' uses.
    (setq
     message-send-mail-function   'smtpmail-send-it
     smtpmail-default-smtp-server "mail.tradedoubler.com"
     smtpmail-smtp-server         "mail.tradedoubler.com"
     smtpmail-local-domain        "tradedoubler.com"
     ;; mu4e-date-format-long        "%Y-%m-%d %H:%M:%S %z"
     mu4e-headers-date-format     "%Y-%m-%d %H:%M:%S %z")

    (setq mu4e-headers-fields
	  '((:human-date . 26)
	    (:flags . 6)
	    (:mailing-list . 10)
	    (:from . 22)
	    (:subject)))

    (assoc ':human-date mu4e-headers-fields)

    (setq mu4e-get-mail-command (home-root "/src/offlineimap/offlineimap.py"))
    (setq mu4e-sent-messages-behavior 'delete)

    (add-hook 'mu4e-compose-pre-hook
	      (defun my-set-from-address ()
		"Set the From address based on the To address of the original."
		(let ((msg mu4e-compose-parent-message) ;; msg is shorter...
		      (message "my-set-from-address called"
			       (setq user-mail-address
				     (cond
				      ((mu4e-contact-field-matches msg :to "andreassen.kjell@gmail.com")
				       "andreassen.kjell@gmail.com")
				      ((mu4e-contact-field-matches msg :to "kjell.andreassen@tradedoubler.com")
				       "kjell.andreassen@tradedoubler.com")
				      (t "kjell.andreassen@tradedoubler.com"))))))))))
