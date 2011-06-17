(require 'emms-setup)
(emms-standard)
;;(emms-default-players)

(emms-all)
(require 'emms-player-simple)
(require 'emms-source-file)
(require 'emms-source-playlist)
(require 'emms-streams)
(require 'emms-playing-time)

(setq emms-player-list '(emms-player-mplayer
                         emms-player-alsaplayer
                         emms-player-mpg321
                         emms-player-ogg123))
(setq emms-source-file-default-directory "/mnt/raid/kjell/music/")
;;(setq emms-playlist-buffer-name "*Music!*")
;;(emms-playing-time 1)

(setq emms-player-mplayer-parameters
      (append emms-player-mplayer-parameters '("-slave")))

(global-set-key (kbd "C-c e s") 'emms-stop)
(global-set-key (kbd "C-c e SPC") 'emms-pause)
(global-set-key (kbd "C-c e <left>")  (lambda () (interactive) (emms-seek -10)))
(global-set-key (kbd "C-c e <right>") (lambda () (interactive) (emms-seek 10)))
(global-set-key (kbd "C-c e <up>")    (lambda () (interactive) (emms-seek -30)))
(global-set-key (kbd "C-c e <down>")  (lambda () (interactive) (emms-seek 30)))
