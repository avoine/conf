(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(defun cmode-hook ()
  ;; defun navigation
  (local-set-key (kbd "C-S-a") 'c-beginning-of-defun)
  (local-set-key (kbd "C-S-e") 'c-end-of-defun)
  ;; compile
  (local-set-key (kbd "C-C c") 'compile)
  (local-set-key (kbd "C-C r") 'recompile)
  (ggtags-mode))

(defun add-kernel-style ()
  (c-add-style
   "linux-tabs-only"
   '("linux" (c-offsets-alist
              (arglist-cont-nonempty
               c-lineup-gcc-asm-reg
               c-lineup-arglist-tabs-only)))))

(defun kernel-style ()
  (setq indent-tabs-mode t)
  (whitespace-mode)
  (c-set-style "linux"))

(defun match-in-list (file file-list)
  (if (null file-list)
      nil
    (or (string-match (regexp-quote (car file-list)) file)
        (match-in-list file (cdr file-list)))))

(defun find-code-style ()
  (let ((filename (buffer-file-name)))
    (when filename
      (cond
       ((match-in-list (file-truename filename) parrot-old-style-list)
        (parrot-old-style))
       ((string-match (expand-file-name "~/") (file-truename filename))
        (parrot-style))
       (t (message "error, no style"))))))

(add-hook 'c-mode-common-hook 'find-code-style)
(add-hook 'c-mode-common-hook 'cmode-hook)
(add-hook 'c-mode-common-hook 'add-kernel-style)
(add-hook 'c-mode-common-hook 'parrot-add-style)
