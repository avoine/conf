(defun woof-file ()
  (interactive)
  ;; because woof is asynchronous, we must loop until it matches
  (defun search-until (regexp)
    (when (null (re-search-forward regexp nil t))
      (sleep-for 0.1)
      (goto-char (point-min))
      (search-until regexp)))
  (let ((program-name "woof")
        (buffer-name "*woof*")
        (exec-name "woof"))
    (when (get-buffer buffer-name)
      (kill-buffer buffer-name))
    (start-process program-name buffer-name exec-name buffer-file-name)
    (with-current-buffer buffer-name
      (search-until "http://.*")
      (let ((link (match-string 0)))
        (message link)
        (kill-new (match-string 0))))))

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun rotate-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))

                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))

                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))

(defun add-to-list-multiple (list elements &optional append)
  (interactive)
  (--map (add-to-list list it append) elements))

(defun sudo-save ()
  (interactive)
  (if (not buffer-file-name)
      (write-file (concat "/sudo:root@localhost:" (ido-read-file-name "File:")))
    (write-file (concat "/sudo:root@localhost:" buffer-file-name))))
