(package-initialize)

(require 'server)
(if (and (fboundp 'server-running-p)
         (not (server-running-p)))
    (server-start))

(mapc (lambda (file)
         (load (concat "~/.emacs.d/lisp/" file)))
       (mapcar 'symbol-name
               '(packages
                 base
                 battery
                 build
                 cursors
                 cmode
                 custom
                 debbugs
                 ediff
                 elisp
                 erc
                 exwm
                 evil
                 bind-map
                 guix
                 file-mode
                 functions
                 gtags
                 ido
                 jabber
                 pdf-tools
                 uniquify
                 magit
                 mu4e
                 org
                 python
                 theme
                 tramp
                 windmove
                 whitespace)))

(setq parrot-dir (expand-file-name "../parrot" lisp-path))
(dolist (file (directory-files parrot-dir t "\\w+.el"))
  (when (file-regular-p file)
    (load file)))
