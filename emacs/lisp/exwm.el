(require 'exwm)
(require 'exwm-config)

(defmacro int (&rest body)
  `(lambda () (interactive) ,@body))

(defmacro my-local-cmd (key cmd)
  `(let* ((kbd-key (kbd ,key))
          ;; the first key of a key sequence is the prefix
          (prefix (aref kbd-key 0)))
     (push prefix exwm-input-prefix-keys)
     (define-key exwm-mode-map kbd-key ,cmd)))

(setq exwm-workspace-show-all-buffers t
      exwm-layout-show-all-buffers t)

(defmacro my-global-cmd (key cmd)
  `(exwm-input-set-key (kbd ,key) ,cmd))

(defmacro my-global-shell-cmd (key cmd)
  `(my-global-cmd ,key (int (start-process-shell-command ,cmd nil ,cmd))))

(defun switch-to-firefox ()
  (let ((buffer (get-buffer "Firefox")))
    (if buffer (switch-to-buffer buffer)
      (message "No Firefox buffer."))))

(my-global-cmd "s-d" (int (shell-command "date")))
(my-global-cmd "s-a" (int (shell-command "acpi")))
(my-global-cmd "s-w" #'exwm-workspace-switch)
(my-global-cmd "s-j" (int (switch-to-firefox)))

(my-global-shell-cmd "s-c" "xterm")
(my-global-shell-cmd "s-C" "cmst")
(my-global-shell-cmd "s-f" "firefox")
(my-global-shell-cmd "s-l" "suspend.sh")

(dotimes (i 10)
  (my-global-cmd (format "s-%d" i)
                 `(lambda ()
                    (interactive)
                    (scroll-bar-mode -1)
                    (exwm-workspace-switch-create ,i))))

;; Make class name the buffer name.
(add-hook 'exwm-update-class-hook
          (lambda ()
            (exwm-workspace-rename-buffer exwm-class-name)))

;; Remove C-c prefix key for xterm.
(add-hook 'exwm-manage-finish-hook
          (lambda ()
            (when (and exwm-class-name
                       (string= exwm-class-name "XTerm"))
              (setq-local exwm-input-prefix-keys '(?\C-x)))))

(exwm-config-ido)
(exwm-enable)

;; compliance with smex
(my-local-cmd "M-x" 'smex)
(my-local-cmd "M-X" 'smex-major-mode-commands)
