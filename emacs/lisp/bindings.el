(defun my-kill-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(defun generic-find-tag ()
  (interactive)
  (call-interactively
   (cond ((bound-and-true-p ggtags-mode) 'ggtags-find-tag-dwim)
         ((string= major-mode "scheme-mode") 'geiser-edit-symbol-at-point)
         ((string= major-mode "emacs-lisp-mode") 'find-function)
         (t (error "wrong mode")))))

(defun generic-pop-stack ()
  (interactive)
  (call-interactively
   (cond ((bound-and-true-p ggtags-mode) 'ggtags-prev-mark)
         ((string= major-mode "scheme-mode") 'geiser-pop-symbol-stack)
         (t (error "wrong mode")))))

(defun find-cervin ()
  (interactive)
  (find-file "/cervin:/home/mathieu"))

(defun find-elbruz ()
  (interactive)
  (find-file "/elbruz:/home/mathieu"))

(defhydra my-hydra-parrot (:color blue)
  "parrot"
  ("a" alchemy-popup "alchemy")
  ("G" gerrit-popup "gerrit")
  ("p" pdir-search "pdir"))

(defhydra my-hydra-tramp (:color blue)
  "tramp"
  ("b" tramp-cleanup-all-buffers "clean buffers")
  ("c" tramp-cleanup-this-connection "clean this"))

(defhydra my-hydra-erc (:color blue)
  "tramp"
  ("f" freenode-connect  "freenode connect")
  ("n" (erc-ghost-m-o)   "ghost")
  ("g" (switch-to-buffer "#guix") "guix")
  ("u" (switch-to-buffer "#guile") "guile")
  ("r" (switch-to-buffer "#ratpoison") "ratpoison"))

(defun backlight (arg)

  (defconst sys-br "/sys/class/backlight/intel_backlight/brightness")
  (defconst sys-max-br "/sys/class/backlight/intel_backlight/max_brightness")

  (defun read-file (file)
    (string-to-number
     (replace-regexp-in-string
      "\n$" ""
      (shell-command-to-string
       (format "cat %s" file)))))

  (defun percentage ()
    (let ((br (read-file sys-br))
          (max-br (read-file sys-max-br)))
      (round (* (/ br (float max-br)) 100.0))))

  (interactive)
  (let* ((val (substring arg 1 nil))
         (cmd (cond
               ((string-prefix-p "+" arg)
                (format "xbacklight -inc %s" val))
               ((string-prefix-p "-" arg)
                (format "xbacklight -dec %s" val))
               ((string-prefix-p "=" arg)
                (format "xbacklight -set %s" val)))))
    (shell-command cmd)
    (message (number-to-string (percentage)))))

(defhydra my-hydra-backlight ()
  "backlight"
  ("1" (backlight "=10") "10")
  ("2" (backlight "=25") "25")
  ("3" (backlight "=50") "50")
  ("4" (backlight "=75") "75")
  ("5" (backlight "=100") "100")
  ("h" (backlight "-1") "down 1")
  ("j" (backlight "-10") "down 10")
  ("k" (backlight "+10") "up 10")
  ("l" (backlight "+1") "up 1"))

(defhydra my-hydra-base (:color blue)
  "base"
  ("0" my-hydra-backlight/body "backlight")
  ("1" my-hydra-erc/body "erc")
  ("2" my-run-geiser "geiser")
  ("4" mu4e-alert-view-unread-mails "mail")
  ("5" find-cervin)
  ("6" find-elbruz)
  ("b" browse-url "url")
  ("c" cleanup-dwim "cleanup")
  ("e" eval-buffer "eval")
  ("g" magit-status "git")
  ("k" my-kill-buffer "kill")
  ("L" goto-line "line")
  ("n" ggtags-next-mark "ggtags-next")
  ("o" rotate-windows)
  ("p" generic-pop-stack "pop")
  ("q" quick-calc "calc")
  ("r" rgrep "rgrep")
  ("R" revert-buffer "revert")
  ("t" generic-find-tag "find")
  ("T" my-hydra-tramp/body "tramp")
  ("w" my-hydra-parrot/body "parrot")
  ("x" guix "guix")
  (";" comment-or-uncomment-region "comment"))

(define-key evil-normal-state-map (kbd "SPC") 'my-hydra-base/body)
(define-key evil-visual-state-map (kbd "SPC") 'my-hydra-base/body)
(define-key global-map (kbd "C-SPC") 'my-hydra-base/body)
