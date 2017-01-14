(defun python-style ()
  (setq python-indent 4)
  (setq indent-tabs-mode nil)
  (whitespace-mode))

(add-hook 'python-mode-hook #'python-style)
