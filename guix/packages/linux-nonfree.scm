(define-module (linux-nonfree)
  #:use-module ((guix licenses) #:hide (zlib))
  #:use-module (gnu packages linux)
  #:use-module (guix build-system trivial)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix download))

(define (linux-nonfree-urls version)
  "Return a list of URLs for Linux-Nonfree VERSION."
  (list (string-append
         "https://www.kernel.org/pub/linux/kernel/v4.x/"
         "linux-" version ".tar.xz")))

(define (linux-nonfree-urls-rc version)
  "Return a list of URLs for Linux-Nonfree VERSION."
  (list (string-append
         "https://cdn.kernel.org/pub/linux/kernel/v4.x/testing/"
         "linux-" version ".tar.xz")))

(define-public linux-nonfree
  (let* ((version "4.9"))
    (package
      (inherit linux-libre)
      (name "linux-nonfree")
      (version version)
      (source (origin
                (method url-fetch)
                (uri (linux-nonfree-urls version))
                (sha256
                 (base32
                  "06kz7m7pdvv47z725fp0ls6q6ml4hbip1sba11g8fx5bzzf9i402"))))
      (synopsis "Mainline Linux kernel, nonfree binary blobs included.")
      (description "Linux is a kernel.")
      (license gpl2)
      (home-page "http://kernel.org/"))))

(define-public linux-rc-guix
  (let* ((version "4.10-rc3"))
    (package
      (inherit linux-libre)
      (name "linux-rc-guix")
      (version version)
      (native-inputs (alist-replace "kconfig" (list "/home/mathieu/linux/config.conf")
                                    (package-native-inputs linux-libre)))
      (arguments
       (substitute-keyword-arguments (package-arguments linux-libre)
         ((#:phases phases)
          `(modify-phases ,phases
             (add-before 'build 'fix-makefiles
                         (lambda _
                           (substitute* (find-files "." "Makefile")
                             (("/bin/pwd") (which "pwd")))))))))
      (source (origin
                (method url-fetch)
                (uri (linux-nonfree-urls-rc version))
                (sha256
                 (base32
                  "15z3wzhryl2p19ra4mjb86pf5lnk3s1pwf8nybhp6ifn131yi5gg"))))
      (synopsis "Mainline Linux kernel, nonfree binary blobs included.")
      (description "Linux is a kernel.")
      (license gpl2)
      (home-page "http://kernel.org/"))))
