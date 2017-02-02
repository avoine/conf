(use-modules (gnu)
             (srfi srfi-1))
(use-package-modules linux)
(use-service-modules desktop cuirass)

(primitive-load "common.scm")

(define %cervin-base-services
  (modify-services (operating-system-user-services %common-os)
    (guix-service-type
     config =>
     (guix-configuration
      (inherit config)
      (substitute-urls
       (cons "http://192.168.0.51"
             (guix-configuration-substitute-urls config)))))
    (udev-service-type
     config =>
     (udev-configuration
      (inherit config)
      (rules
       (cons* tlp
              (udev-configuration-rules config)))))))

(operating-system
  (inherit %common-os)
  (host-name "cervin")
  (kernel-arguments '("acpi_backlight=video thinkpad_acpi.debug=0xffff pcie_aspm=force"))
  (packages (cons tlp (operating-system-packages %common-os)))
  (services %cervin-base-services))
