(setq eshell-history-size 10000)

(defun eshell/e (file)
  (find-file file))

(defun eshell/ll (&optional args)
  (eshell/ls "-lrth" args))

(defun eshell/la (&optional args)
  (eshell/ls "-lArth" args))

(defun eshell/ssh (name)
  (insert (concat "cd /ssh:" name ":~"))
  (eshell-send-input))

;; makes Eshell’s `ls' file names RET-able
(eval-after-load "em-ls"
  '(progn
     (defun ted-eshell-ls-find-file-at-point (point)
       "RET on Eshell's `ls' output to open files."
       (interactive "d")
       (find-file (buffer-substring-no-properties
                   (previous-single-property-change point 'help-echo)
                   (next-single-property-change point 'help-echo))))

     (defun pat-eshell-ls-find-file-at-mouse-click (event)
       "Middle click on Eshell's `ls' output to open files.
 From Patrick Anderson via the wiki."
       (interactive "e")
       (ted-eshell-ls-find-file-at-point (posn-point (event-end event))))

     (let ((map (make-sparse-keymap)))
       (define-key map (kbd "RET")      'ted-eshell-ls-find-file-at-point)
       (define-key map (kbd "<return>") 'ted-eshell-ls-find-file-at-point)
       (define-key map (kbd "<mouse-2>") 'pat-eshell-ls-find-file-at-mouse-click)
       (defvar ted-eshell-ls-keymap map))

     (defadvice eshell-ls-decorated-name (after ted-electrify-ls activate)
       "Eshell's `ls' now lets you click or RET on file names to open them."
       (add-text-properties 0 (length ad-return-value)
                            (list 'help-echo "RET, mouse-2: visit this file"
                                  'mouse-face 'highlight
                                  'keymap ted-eshell-ls-keymap)
                            ad-return-value)
       ad-return-value)))

(defun eshell-git-prompt-clem ()
  ;; Prompt components
  (let (beg dir git-branch git-dirty end)
    ;; Beg: start symbol
    (setq beg
          (with-face "➜"
            :foreground (if (eshell-git-prompt-exit-success-p)
                            "green" "red")))

    ;; Dir: current working directory
    (setq dir (with-face (substring (abbreviate-file-name default-directory) 0 -1)
                :foreground "cyan"))

    ;; Git: branch/detached head, dirty status
    (when (eshell-git-prompt--git-root-dir)
      (setq eshell-git-prompt-branch-name (eshell-git-prompt--branch-name))

      (setq git-branch
            (concat
             (with-face "git:(" :foreground "blue")
             (with-face (eshell-git-prompt--readable-branch-name) :foreground "red")
             (with-face ")" :foreground "blue")))

      (setq git-dirty
            (when (eshell-git-prompt--collect-status)
              (with-face "✗" :foreground "yellow"))))

    ;; End: To make it possible to let `eshell-prompt-regexp' to match the full prompt
    (setq end (propertize "$" 'invisible t))

    ;; Build prompt
    (concat (s-join " " (-non-nil (list beg dir git-branch git-dirty)))
            end
            " ")))

(require 'eshell-git-prompt)
(add-to-list 'eshell-git-prompt-themes '(clem
                                         eshell-git-prompt-clem
                                         eshell-git-prompt-robbyrussell-regexp))
(eshell-git-prompt-use-theme 'clem)

;; eshell coloration
(add-hook 'eshell-mode-hook
          '(lambda ()
             (setenv "TERM" "xterm")))
(defun eshell-kill-maybe ()
  (interactive)
  (if (equal (current-buffer) (get-buffer "*eshell*"))
      (let ((dd default-directory))
        (kill-buffer "*eshell*")
        (with-temp-buffer
          (setq default-directory dd)
          (call-interactively 'eshell)))
    (when (get-buffer "*eshell*")
      (kill-buffer "*eshell*"))
    (call-interactively 'eshell)))

(defun ido-enter-eshell ()
  (interactive)
  (with-no-warnings
    (setq ido-exit 'fallback fallback 'eshell-kill-maybe))
  (exit-minibuffer))

(defun ido-eshell ()
  (define-key ido-completion-map
    (kbd "C-c e") 'ido-enter-eshell))

(add-hook 'ido-setup-hook 'ido-eshell)
