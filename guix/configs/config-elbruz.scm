(use-modules (gnu))
(use-service-modules desktop cuirass)

(primitive-load "config-common.scm")

(define %cuirass-specs
  ;; Cuirass specifications to build Guix.
  #~(list `((#:name . "guix")
            (#:url . "git://git.savannah.gnu.org/guix.git")
            (#:branch . "master")
            (#:no-compile? #t)
            (#:load-path . ".")
            (#:proc . drv-list)
            (#:file . #$(local-file "/home/mathieu/conf/guix/cuirass/guix-drv.scm")))))

(define %elbruz-base-services
  (cons*
   (guix-publish-service #:port 8081 #:host "0.0.0.0")
   (service cuirass-service-type
            (cuirass-configuration
             (interval 30)
             (use-substitutes? #t)
             (port 8082)
             (env (list "GUIX_PACKAGE_PATH=/home/mathieu/conf/guix/packages"))
             (specifications %cuirass-specs)))
   %common-services))

(operating-system
  (inherit %common-os)
  (host-name "elbruz")
  (kernel-arguments '("modprobe.blacklist=pcspkr"))
  (services %elbruz-base-services))
