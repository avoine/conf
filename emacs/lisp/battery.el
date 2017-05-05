(defconst useless-services '("ntpd"
                             "wpa-supplicant"))

(defconst rf-interfaces '("wlan"))

(defconst hungry-processes '("xterm"
                             "firefox"))


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
