(defun disable-scrollbars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))

(defun gui-theme ()
  (setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)
        alect-display-class '((class color) ; enable alect in 256-color terms
                              (min-colors 256)))

  (load-theme 'alect-black t)
  (set-face-attribute 'default nil :height 130) ; value in 1/10pt (100 = 10pts)

  (when window-system
    (global-hl-line-mode 1))

  (menu-bar-mode -1)
  (toggle-scroll-bar -1)
  (tool-bar-mode -1))

(defun term-theme ()
  (menu-bar-mode -1)
  (load-theme 'tango-dark t))

(if (display-graphic-p)
    (gui-theme)
  (term-theme))
