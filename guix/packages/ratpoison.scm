(define-module (mat ratpoison)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix git-download)
  #:use-module (gnu packages)
  #:use-module (gnu packages ratpoison)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages xorg)
  #:use-module (srfi srfi-1))

(define-public ratpoison-xrandr
  (package
    (inherit ratpoison)
    (version "1.4.8")
    (name "ratpoison-xrandr")
    (source (origin
              (inherit (package-source ratpoison))
              (method git-fetch)
              (uri (git-reference
                    (url "git://git.savannah.nongnu.org/ratpoison.git")
                    (commit "xrandr")))
              (sha256
               (base32
                "0g3pvmk72j4b4xgk4g69yc61zkkzfbb7rnpkn9s9xbsqsp7a796s"))))
    (arguments
     `(,@(substitute-keyword-arguments (package-arguments ratpoison)
           ((#:phases phases)
            `(modify-phases ,phases
               (add-before
                'configure 'autogen
                (lambda _ (zero? (system* "./autogen.sh")))))))))
    (native-inputs
     `(("autoconf" ,autoconf)
       ("automake" ,automake)
       ("makeinfo" ,texinfo)
       ,@(package-native-inputs ratpoison)))
    (inputs
     `(("libxrandr" ,libxrandr)
       ,@(alist-delete "libxinerama"
                       (package-inputs ratpoison)
                       equal?)))))
