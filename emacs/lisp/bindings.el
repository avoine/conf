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

(defhydra my-hydra-base (:color blue)
  "base"
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
  ("w" my-hydra-parrot/body "parrot")
  ("x" guix "guix")
  (";" comment-or-uncomment-region "comment"))

(define-key evil-normal-state-map (kbd "SPC") 'my-hydra-base/body)
(define-key evil-visual-state-map (kbd "SPC") 'my-hydra-base/body)
(define-key global-map (kbd "C-SPC") 'my-hydra-base/body)
