(define-module (autoconf)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages xorg))

(define-public autoconf-2.13
  ;; As of GDB 7.8, GDB is still developed using this version of Autoconf.
  (package (inherit autoconf)
    (version "2.13")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnu/autoconf/autoconf-"
                          version ".tar.gz"))
      (sha256
       (base32
        "07krzl4czczdsgzrrw9fiqx35xcf32naf751khg821g5pqv12qgh"))))
    (native-inputs
     `(("autoconf" ,(autoconf-wrapper))
       ("automake" ,automake)
       ("libtool" ,libtool)))
    (arguments
     '(#:phases (modify-phases %standard-phases
                  (add-before 'configure 'add-automake-files
                    (lambda _
                      (delete-file "configure")   ;it's read-only
                      (zero? (system* "autoreconf" "-vfi")))))))))
