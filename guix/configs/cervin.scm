(use-modules (gnu)
             (srfi srfi-1))
(use-service-modules desktop)

(primitive-load "common.scm")

(define %cervin-base-services
  (modify-services (operating-system-user-services %common-os)
    (guix-service-type
     config =>
     (guix-configuration
      (inherit config)
      (substitute-urls
       (cons "http://192.168.0.20"
             (guix-configuration-substitute-urls config)))))))

(operating-system
  (inherit %common-os)
  (host-name "cervin")
  (kernel-arguments '("acpi_backlight=video thinkpad_acpi.debug=0xffff pcie_aspm=force"))
  (services %cervin-base-services))
