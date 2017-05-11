(bind-map leader-map
          :keys ("C-SPC")
          :evil-keys ("SPC")
          :evil-states (normal motion visual))

(defmacro int (&rest body)
  `(lambda () (interactive) ,@body))

(bind-map-set-keys leader-map
  "<f3>" (int (switch-to-buffer "#guile"))
  "<f4>" (int (switch-to-buffer "#guix"))
  "1" (int (find-file "~/orgmode/home.org"))
  "2" 'my-run-geiser
  "4" (int (mu4e-alert-view-unread-mails))
  "5" (int (find-file "/cervin:/home/mathieu"))
  "6" (int (find-file "/elbruz:/home/mathieu"))
  "a" 'alchemy-popup
  "b" 'browse-url
  "d" 'delete-trailing-whitespace
  "c" 'cleanup-dwim
  "e" 'eval-buffer
  "f" 'ag-dired
  "F" 'freenode-connect
  "g" 'magit-status
  "G" 'gerrit-popup
  "h" 'make-cursors-dwim
  "i" (lambda () (interactive) (make-cursors-dwim 4))
  "j" (lambda () (interactive) (evil-mc-undo-all-cursors) (evil-mc-mode 0))
  "k" (int (kill-buffer (current-buffer)))
  "K" 'kill-buffer-and-window
  "L" 'goto-line
  "n" 'ggtags-next-mark
  "o" 'rotate-windows
  "p" 'generic-pop-stack
  "q" 'quick-calc
  "r" 'ag
  "R" 'revert-buffer
  "s" 'pdir-search
  "t" 'generic-find-tag
  "x" 'guix
  ";" 'comment-or-uncomment-region
  )

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
