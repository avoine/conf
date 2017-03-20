(add-to-list 'load-path "~/.guix-profile/share/emacs/site-lisp/")
(require 'guix-autoloads nil t)

(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/guix"))

(add-hook 'scheme-mode-hook 'guix-devel-mode)

(defun my-run-geiser ()
  (interactive)
  (let ((buf (current-buffer)))
    (run-guile)
    (switch-to-buffer buf)))

(add-to-list 'completion-ignored-extensions ".go")
