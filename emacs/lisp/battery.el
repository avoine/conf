(defconst useless-services '("ntpd"
                             "wpa-supplicant"))

(defconst rf-interfaces '("wlan"))

(defconst hungry-processes '("xterm"
                             "firefox"))


;;
;; Backlight.
;;

(defun backlight (arg)

  (defconst sys-br "/sys/class/backlight/intel_backlight/brightness")
  (defconst sys-max-br "/sys/class/backlight/intel_backlight/max_brightness")

  (defun read-file (file)
    (string-to-number
     (replace-regexp-in-string
      "\n$" ""
      (shell-command-to-string
       (format "cat %s" file)))))

  (defun percentage ()
    (let ((br (read-file sys-br))
          (max-br (read-file sys-max-br)))
      (round (* (/ br (float max-br)) 100.0))))

  (interactive)
  (let* ((val (substring arg 1 nil))
         (cmd (cond
               ((string-prefix-p "+" arg)
                (format "xbacklight -inc %s" val))
               ((string-prefix-p "-" arg)
                (format "xbacklight -dec %s" val))
               ((string-prefix-p "=" arg)
                (format "xbacklight -set %s" val)))))
    (shell-command cmd)
    (message (number-to-string (percentage)))))


;;
;; Stopping procedures
;;

(defun stop-useless-services ()
  (dolist (service useless-services)
    (shell-command (format "sudo herd stop %s" service))))

(defun stop-rf-interfaces ()
  (dolist (interface rf-interfaces)
    (shell-command (format "sudo rfkill block %s" interface))))

(defun stop-hungry-processes ()
  (dolist (processes hungry-processes)
    (shell-command (format "killall %s" processes))))

(defun stop-mu4e-fetching ()
  (setq mu4e-update-interval nil)
  (mu4e-really-quit))


;;
;; Starting procedures.
;;

(defun start-useless-services ()
  (dolist (service useless-services)
    (shell-command (format "sudo herd start %s" service))))

(defun start-rf-interfaces ()
  (dolist (interface rf-interfaces)
    (shell-command (format "sudo rfkill unblock %s" interface))))

(defun start-mu4e-fetching ()
  (setq mu4e-update-interval 60))


;;
;; Interface procedures.
;;

(defun battery-optimize ()
  (interactive)
  (backlight "=10")
  (stop-useless-services)
  (stop-rf-interfaces)
  (stop-hungry-processes)
  (stop-mu4e-fetching)
  (message "Optimized for battery mode."))

(defun ac-optimize ()
  (interactive)
  (start-useless-services)
  (start-rf-interfaces)
  (start-mu4e-fetching)
  (message "Optimized for ac mode."))
