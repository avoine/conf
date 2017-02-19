(require 'magit)

(setq evil-want-C-i-jump nil)
(require 'evil)

(evil-mode 1)
(global-undo-tree-mode -1)
(setq evil-symbol-word-search t)

(global-set-key (kbd "M-*") 'ace-jump-mode)

(add-hook 'prog-mode-hook '(lambda () (setq evil-symbol-word-search t)))
(add-hook 'prog-mode-hook '(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'prog-mode-hook '(lambda () (modify-syntax-entry ?- "w")))

(require 'evil-mc)

(setq emacs-state-modes
      '(cscope-list-entry-mode
        Info-mode
        debbugs-gnu-mode
        pdir-mode
        Man-mode
        lsgit-mode
        geiser-debug-mode
        gerrit-mode))

(--map (evil-set-initial-state it 'emacs) emacs-state-modes)

(evil-make-overriding-map magit-blame-mode-map 'normal)
(add-hook 'edebug-mode-hook 'evil-normalize-keymaps)
(add-hook 'magit-blame-mode-hook 'evil-normalize-keymaps)
(add-hook 'cscope-list-entry-hook 'evil-change-to-initial-state)

(setq evil-normal-state-modes
      '(pdf-view-mode
        pdf-outline-buffer-mode
        pdf-occur-buffer-mode))

(--map (evil-set-initial-state it 'normal) evil-normal-state-modes)

(defun kikoo ()
  (interactive)
  (message "KIKOO"))

(define-key evil-insert-state-map [left] 'kikoo)
(define-key evil-insert-state-map [right] 'kikoo)
(define-key evil-insert-state-map [up] 'kikoo)
(define-key evil-insert-state-map [down] 'kikoo)

(define-key evil-motion-state-map [left] 'kikoo)
(define-key evil-motion-state-map [right] 'kikoo)
(define-key evil-motion-state-map [up] 'kikoo)
(define-key evil-motion-state-map [down] 'kikoo)

(defun my-move-key (keymap-from keymap-to key)
  "Moves key binding from one keymap to another, deleting from the old location. "
  (define-key keymap-to key (lookup-key keymap-from key))
  (define-key keymap-from key nil))
(my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
(my-move-key evil-motion-state-map evil-normal-state-map " ")
