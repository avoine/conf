(setq whitespace-style '(face
                         trailing
                         lines-tail
                         space-before-tab
                         newline
                         empty
                         space-after-tab))

(defun cleanup-dwim ()
  (interactive)
  (let (begin end)
    (if (evil-visual-state-p)
        (setq begin evil-visual-beginning
              end evil-visual-end)
      (setq begin (point-min)
            end (point-max)))
    (indent-region begin end)
    (whitespace-cleanup-region begin end)))
