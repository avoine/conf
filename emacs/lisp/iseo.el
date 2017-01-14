(provide 'iseo_headers)

(defun parse_args (args-list)
  "Recursively get names of arguments."
  (if args-list
      (if (string-match
           (concat
            "[ \t\n]*"
            "\\(.*\\)"
            " \\(.*\\)\\'"
            ) (car args-list))
          (cons
           (cons (substring (car args-list) (match-beginning 1) (match-end 1))
                 (substring (car args-list) (match-beginning 2) (match-end 2)))
           (parse_args (cdr args-list)))
        ;; else there is no match
        nil)))

(defun prepare_args (args)
  (parse_args
   (split-string
    (replace-regexp-in-string "\n" "" args)
    ","
    ))
)

(setq header_begin_format 
      (concat 
       "/*------------------------------------------------------------------------*\n"
       "*  FONCTION          : %s\n"
       "*  DESCRIPTION       : - \n"
       ))

(setq header_in_format "*  ARGUMENT ENTREE   : %s\n")      
(setq header_out_format "*  ARGUMENT SORTIE   : %s\n")      

(setq header_end_format 
      (concat 
       "*  RETOUR            : %s\n"
       "*  NOTES TECHNIQUES  : - \n"
       "*--------------------------------------------------------------------------*\n"
       "*    HISTORIQUE DES MODIFICATIONS:\n"
       "*    Date    Auteur	Description\n"
       "* %s	%s	-\n"
       "*--------------------------------------------------------------------------*/\n"
       ))
       
(defun insert-args (list)
  (dolist (elt list) 
    (insert     
      (format header_in_format  (cdr elt))))
)

;(insert-args (prepare_args "char* a,\n int b"))

(defun parse_function (str)
  "Recursively get names of arguments."
  (if str
      (if (string-match
           (concat
            "\\(.*\\)" ;retour
            "[\n ]+\\([a-zA-Z0-9_]+\\)" ;nom fonction
            "[ ]*(\\([^)]*\\))"
            ) str)
          (let ((pt (+ (point) (match-beginning 1)))
		(ret_f (substring str (match-beginning 1) (match-end 1)))
                (nom_f (substring str (match-beginning 2) (match-end 2)))
                (arg_f (prepare_args (substring str (match-beginning 3) (match-end 3)))))
	    (goto-char pt)
            (insert (format header_begin_format nom_f))
	    (insert-args arg_f)
            (insert (format header_end_format ret_f (format-time-string "%d/%m/%Y") "MOT")))
        )))


;(parse_args testa)

;(parse_function testb)

(defun append-to-buffer (buffer start end)
  "Append to specified buffer the text of the region.
..."
  (interactive "BAppend to buffer: \nr")
  (let ((oldbuf (current-buffer)))
    (save-excursion
      (set-buffer (get-buffer-create buffer))
      (insert-buffer-substring oldbuf start end))))


(defun iseo_create_function_header ()
  "Cree un header de fonction (cartouche) au format iseo"
  (interactive)
  (let
      ((myStr (buffer-substring-no-properties (point) (point-max))))
    (parse_function myStr))
  )

(defun custom_rgrep (dir pattern)
  (interactive "DSearch directory : \nMPattern : ")
  (grep-compute-defaults)
  (grep-find (concat "find " dir " -type f -print0 | xargs -0 -e grep --color -n -e \"" pattern "\""))
)

(defun iseo_custom_rgrep ()
  (interactive)
  (let
      ((default-directory "/home/xair/prog/C/"))
    (call-interactively 'custom_rgrep))
)
