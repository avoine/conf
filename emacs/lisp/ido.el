(ido-mode 1)
(ido-everywhere 1)

(require 'ido-ubiquitous)
(ido-ubiquitous-mode)

(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(setq ido-auto-merge-work-directories-length -1
      ido-enable-flex-matching t)

(require 'magit)

(defun ido-enter-eshell ()
  (interactive)
  (with-no-warnings
    (setq ido-exit 'fallback fallback 'eshell-kill-maybe))
  (exit-minibuffer))

(define-key ido-common-completion-map
  (kbd "C-x e") 'ido-enter-eshell)

(define-key ido-common-completion-map
  (kbd "C-x g") 'ido-enter-magit-status)
