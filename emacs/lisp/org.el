(require 'org)

(define-key org-mode-map (kbd "C-c C-g") 'org-todo)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-agenda-start-with-log-mode t
      org-html-validation-link nil
      org-html-postamble t
      org-html-postamble-format '(("en" "<p class=\"postamble\">Created by %c</p>")))
