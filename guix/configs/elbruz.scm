(use-modules (gnu))
(use-service-modules desktop cuirass)

(primitive-load "common.scm")

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
   (static-networking-service "enp0s25"
                              "192.168.0.51"
                              #:gateway "192.168.0.1"
                              #:name-servers (list "8.8.8.8"))
   (guix-publish-service #:host "0.0.0.0")
   (service cuirass-service-type
            (cuirass-configuration
             (interval 30)
             (use-substitutes? #t)
             (port 8082)
             (load-path '("/home/mathieu/conf/guix/common_packages"))
             ;; (load-path '("/home/mathieu/conf/guix/packages"
             ;;              "/home/mathieu/conf/guix/common_packages"))
             (specifications %cuirass-specs)))
   (operating-system-user-services %common-os)))

(operating-system
  (inherit %common-os)
  (host-name "elbruz")
  (kernel-arguments '("modprobe.blacklist=pcspkr"))
  (services %elbruz-base-services))
