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
      ag-highlight-search t
      x-select-enable-primary t)

(setq-default
 mode-line-format
 (cons '(:eval (number-to-string exwm-workspace-current-index))
       mode-line-format))

(global-font-lock-mode t)
(global-page-break-lines-mode t)
(show-paren-mode)
(blink-cursor-mode -1)

(defalias 'yes-or-no-p 'y-or-n-p)

