(require 'pdf-tools)
(require 'evil)

(pdf-tools-install)

(evil-define-key 'normal pdf-view-mode-map
  ;; Navigation
  "j"  'pdf-view-next-line-or-next-page
  "k"  'pdf-view-previous-line-or-previous-page
  "l"  'image-forward-hscroll
  "h"  'image-backward-hscroll
  "J"  'pdf-view-next-page
  "K"  'pdf-view-previous-page
  "gg"  'pdf-view-first-page
  "G"  'pdf-view-last-page
  "gt"  'pdf-view-goto-page
  "gl"  'pdf-view-goto-label
  "u" 'pdf-view-scroll-down-or-previous-page
  "d" 'pdf-view-scroll-up-or-next-page
  (kbd "C-u") 'pdf-view-scroll-down-or-previous-page
  (kbd "C-d") 'pdf-view-scroll-up-or-next-page
  (kbd "``")  'pdf-history-backward
  ;; Search
  "/" 'isearch-forward
  "?" 'isearch-backward
  ;; Actions
  "r"   'pdf-view-revert-buffer
  "o"   'pdf-outline
  "O"   'pdf-occur
  (kbd "C-l") 'pdf-links-action-perform)


(evil-define-key 'normal pdf-outline-buffer-mode-map
  "-"                'negative-argument
  "j"                'next-line
  "k"                'previous-line
  "gk"               'outline-backward-same-level
  "gj"               'outline-forward-same-level
  (kbd "<backtab>")  'show-all
  "gh"               'pdf-outline-up-heading
  "gg"               'beginning-of-buffer
  "G"                'pdf-outline-end-of-buffer
  "TAB"              'outline-toggle-children
  (kbd "RET")        'pdf-outline-follow-link
  (kbd "M-RET")      'pdf-outline-follow-link-and-quit
  "f"                'pdf-outline-display-link
  [mouse-1]          'pdf-outline-mouse-display-link
  "o"                'pdf-outline-select-pdf-window
  "``"               'pdf-outline-move-to-current-page
  "''"               'pdf-outline-move-to-current-page
  "Q"                'pdf-outline-quit-and-kill
  "q"                'quit-window
  "F"                'pdf-outline-follow-mode)

(evil-define-key 'normal pdf-annot-list-mode-map
  "f"                'pdf-annot-list-display-annotation-from-id
  "d"                'tablist-flag-forward
  "x"                'tablist-do-flagged-delete
  "u"                'tablist-unmark-forward
  "q"                'tablist-quit)

(evil-define-key 'normal pdf-occur-buffer-mode-map
  "q"              'tablist-quit
  "g"              'pdf-occur-revert-buffer-with-args
  "r"              'pdf-occur-revert-buffer-with-args
  (kbd "RET")      'pdf-occur-goto-occurrence
  "?"              'evil-search-backward)
