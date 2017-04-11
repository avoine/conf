(setq auto-save-default nil
      backup-inhibited t
      column-number-mode t
      inhibit-startup-message t
      lisp-path (expand-file-name "~/.emacs.d/lisp/")
      custom-file (expand-file-name "custom.el" lisp-path)
      vc-follow-symlinks t
      visible-bell 1
      truncate-lines t
      shell-file-name "bash"
      geiser-active-implementations '(guile)
      geiser-repl-use-other-window nil
      ad-redefinition-action 'accept
      x-select-enable-primary t)

(global-font-lock-mode t)
(global-page-break-lines-mode t)
(show-paren-mode)

(defalias 'yes-or-no-p 'y-or-n-p)

