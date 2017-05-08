(add-to-list 'load-path "~/.guix-profile/share/emacs/site-lisp/")
(require 'guix-autoloads nil t)

(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/guix"))

(defun my-run-geiser ()
  (interactive)
  (let ((buf (current-buffer)))
    (run-guile)
    (switch-to-buffer buf)))

(add-to-list 'completion-ignored-extensions ".go")

(defun guix-update-commit-msg ()
  (interactive)
  (let* ((diff  (buffer-string))
         (match (string-match "name \"\\(.*?\\)\"" diff))
         (name  (match-string-no-properties 1 diff))
         (match (string-match "\+.*version \"\\(.*?\\)\"" diff))
         (version (match-string-no-properties 1 diff))
         (match (string-match "gnu/packages/\\(.*?\.scm\\)" diff))
         (package (match-string-no-properties 1 diff)))
    (kill-new (format "gnu: %s: Update to %s.

* gnu/packages/%s (%s): Update to %s." name version package name version))))
