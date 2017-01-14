(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'smtpmail)
(require 'mu4e)

(global-set-key (kbd "C-c m") 'mu4e~headers-jump-to-maildir)

(setq mu4e-maildir "~/mail"
      mu4e-headers-show-threads nil
      mu4e-use-fancy-chars t
      mu4e-get-mail-command "true"
      mu4e-update-interval 60
      message-send-mail-function 'smtpmail-send-it
      mail-specify-envelope-from t
      mail-envelope-from 'header
      mu4e-hide-index-messages t
      mu4e-attachment-dir  "~/Downloads"
      mu4e-show-images t
      message-kill-buffer-on-exit t
      mu4e-split-view 'vertical
      mu4e-headers-visible-columns 100
      mu4e-context-policy 'pick-first
      mu4e-html2text-command "w3m -dump -T text/html"
      mu4e-get-mail-command "mbsync -a"
      mu4e-headers-auto-update t
      mu4e-compose-signature-auto-include nil)

(setq mu4e-maildir-shortcuts
      '(("/gmail/INBOX"                   . ?i)
        ("/gmail/Personnel/.linux-usb"    . ?u)
        ("/gmail/Personnel/.guix"         . ?g)
        ("/parrot/INBOX"                  . ?p)))

(setq mu4e-headers-fields '((:human-date    .   12)
                            (:flags         .    6)
                            (:from-or-to    .   22)
                            (:subject       .   nil)))

(setq mu4e-contexts
      `(,(make-mu4e-context
          :name "Gmail"
          :enter-func (lambda () (mu4e-message "Switch to Gmail context"))
          :match-func (lambda (msg)
                        (when msg
                          (string-match "/gmail/"
                                        (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "m.othacehe@gmail.com")
                  (user-full-name . "Mathieu OTHACEHE")
                  (mu4e-sent-folder . "/gmail/sent/")
                  (mu4e-drafts-folder . "/gmail/drafts")
                  (mu4e-trash-folder . "/gmail/trash")
                  (smtpmail-smtp-user . "m.othacehe@gmail.com")
                  (smtpmail-default-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-service . 587)))
        ,(make-mu4e-context
          :name "Parrot"
          :enter-func (lambda () (mu4e-message "Switch to the Parrot context"))
          :match-func (lambda (msg)
                        (when msg
                          (string-match "/parrot/"
                                        (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "mathieu.othacehe@parrot.com")
                  (user-full-name . "Mathieu OTHACEHE")
                  (mu4e-sent-folder . "/parrot/sent")
                  (mu4e-drafts-folder . "/parrot/drafts")
                  (mu4e-trash-folder . "/parrot/trash")
                  (smtpmail-smtp-user . "mathieu.othacehe@parrot.com")
                  (smtpmail-default-smtp-server . "smtp.aswsp.com")
                  (smtpmail-smtp-server . "smtp.aswsp.com")
                  (smtpmail-smtp-service. 587)))))

(add-hook 'mu4e-view-mode-hook 'mu4e-mark-region-code)

(defun linux-apply (msg)
  "Apply and commit the git [patch] message."
  (interactive)
  (let ((path "~/linux"))
    (setf ido-work-directory-list
          (cons path (delete path ido-work-directory-list)))
    (shell-command
     (format "cd %s; git am %s"
             path
             (mu4e-message-field msg :path)))))

(defun mu4e-show-old-lkml ()
    (interactive)
    (let ((mu4e-headers-results-limit -1))
      (mu4e-headers-search "maildir:\"/gmail/Personnel/.lkml\" date:2d..now")))

(define-key mu4e-headers-mode-map "K"
  '(lambda ()
     (interactive)
     (while (mu4e-headers-mark-for-delete))))

(add-to-list-multiple 'mu4e-headers-actions
                      '(("linux apply" . linux-apply)
                        ("git am"      . mu4e-action-git-apply-mbox)))

(add-to-list-multiple 'mu4e-view-actions '(("browser" . mu4e-action-view-in-browser)
                                           ("xwidget" . mu4e-action-view-with-xwidget)))

(defun mu4e-view-message-no-split ()
  (interactive)
  (let ((mu4e-split-view 'f))
    (mu4e-headers-view-message)))

(define-key mu4e-headers-mode-map (kbd "O") 'mu4e-view-message-no-split)

(defun mu4e-really-quit ()
  (interactive)
  (mu4e~stop))

(defun mu4e-quit ()
  (interactive)
  (switch-to-buffer (other-buffer)))

(mu4e 't)
