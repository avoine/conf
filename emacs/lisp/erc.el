(require 'erc)

(setq erc-join-buffer 'bury
      erc-current-nick-highlight-type 'nick
      erc-echo-notices-in-minibuffer-flag t
      erc-track-exclude-server-buffer t
      erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE")
      erc-log-channels-directory "~/.irclogs/")

(defun freenode-connect ()
  (interactive)
  (erc :server "chat.freenode.net"
       :port "6667"
       :nick "mothacehe"
       :password "lolilol"
       :full-name "Mathieu OTHACEHE"))

(defun parrot-connect ()
  (interactive)
  (erc-tls :server "jinan.parrot.biz"
           :port "7000"
           :nick "Mathieu"
           :full-name "Mathieu OTHACEHE"))

(setq erc-autojoin-channels-alist
      '(("freenode.net"
         "#ratpoison"
         "#guix")
        ("irc.parrot.com"
         "#minidrones"
         "#emacs")))
