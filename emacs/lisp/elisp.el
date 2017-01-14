(require 'highlight-parentheses)

(defun cust-lisp-hook ()
     (enable-paredit-mode)
     (setq indent-tabs-mode nil)
     (whitespace-mode)
     (highlight-parentheses-mode))

(defun cust-repl-hook ()
  (enable-paredit-mode)
  (highlight-parentheses-mode))

(add-hook 'emacs-lisp-mode-hook       'cust-lisp-hook)
(add-hook 'lisp-mode-hook             'cust-lisp-hook)
(add-hook 'lisp-interaction-mode-hook 'cust-lisp-hook)
(add-hook 'scheme-mode-hook           'cust-lisp-hook)

(add-hook 'geiser-repl-mode-hook 'cust-repl-hook)
