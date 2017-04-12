(require 'erc)

(setq my-keywords '("linux"
                    "connman"
                    "cuirass"
                    "ratpoison"))

(setq erc-autojoin-channels-alist
      '(("freenode.net"
         "#ratpoison"
         "#guix")
        ("irc.parrot.com"
         "#minidrones"
         "#emacs")))

(setq erc-join-buffer 'bury
      erc-current-nick-highlight-type 'nick
      erc-track-exclude-server-buffer t
      erc-keywords (mapcar (lambda (str) (concat "\\b" str "\\b")) my-keywords)
      ;; all channels except private conversations (horrible hack)
      erc-track-priority-faces-only (apply 'append erc-autojoin-channels-alist)
      erc-track-faces-priority-list '(erc-current-nick-face erc-keyword-face)
      erc-track-exclude-types '("JOIN" "PART" "QUIT" "NICK" "MODE"
                                "324" "329" "332" "333" "353" "477"))

(defun freenode-connect ()
  (interactive)
  (erc :server "chat.freenode.net"
       :port "6667"
       :nick "m-o"
       :password "lolilol"
       :full-name "Mathieu Othacehe"))

(defun parrot-connect ()
  (interactive)
  (erc-tls :server "jinan.parrot.biz"
           :port "7000"
           :nick "Mathieu"
           :full-name "Mathieu Othacehe"))
