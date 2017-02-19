(defun guix-debbugs-packages ()
  (interactive)
  (debbugs-gnu nil "guix-patches"))

(defun guix-debbugs-bugs ()
  (interactive)
  (debbugs-gnu nil "guix"))

(defun my-debbugs-gnu-select-report (orig-fun &rest args)
  (interactive)
  (let* ((status (debbugs-gnu-current-status))
         (id (cdr (assq 'id status))))
    (mu4e-headers-search (concat (number-to-string id) "@debbugs.gnu.org")
                         nil nil t nil nil)))

(advice-add 'debbugs-gnu-select-report :around #'my-debbugs-gnu-select-report)
