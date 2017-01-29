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
(require 'magit-extras)

(define-key ido-common-completion-map
  (kbd "C-x g") 'ido-enter-magit-status)

(defun ido-fallback-other-window ()
  (interactive)
  (find-file-other-window (concat ido-current-directory (car ido-matches))))

(defun ido-open-other-window ()
  (interactive)
  (with-no-warnings
    (setq ido-exit 'fallback
          fallback 'ido-fallback-other-window))
  (exit-minibuffer))

(define-key ido-common-completion-map
  (kbd "C-x o") 'ido-open-other-window)
