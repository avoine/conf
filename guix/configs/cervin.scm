(use-modules (gnu)
             (srfi srfi-1))
(use-package-modules laptop)
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

(define %cervin-base-services
  (cons*
   (service cuirass-service-type
            (cuirass-configuration
             (interval 30)
             (use-substitutes? #t)
             (port 8082)
             ;; (load-path '("/home/mathieu/conf/guix/packages"
             ;;              "/home/mathieu/conf/guix/common_packages"))
             (specifications %cuirass-specs)))

   (modify-services (operating-system-user-services %common-os)
     (guix-service-type
      config =>
      (guix-configuration
       (inherit config)
       (substitute-urls
        (cons "http://192.168.0.20"
              (guix-configuration-substitute-urls config)))))
     (udev-service-type
      config =>
      (udev-configuration
       (inherit config)
       (rules
        (cons* tlp
               (udev-rule "99-kikoo.rules"
                          "SUBSYSTEM==\"power_supply\" ACTION==\"change\" RUN+=\"/gnu/store/qkw4zrwfybxww8f56nkb6hggxambk89b-bash-4.4.0/bin/sh /tmp/lol_tlp\"\n")
               (udev-configuration-rules config))))))))

(operating-system
  (inherit %common-os)
  (host-name "cervin")
  (kernel-arguments '("acpi_backlight=video thinkpad_acpi.debug=0xffff pcie_aspm=force"))
  (packages (cons tlp (operating-system-packages %common-os)))
  (services %cervin-base-services))
