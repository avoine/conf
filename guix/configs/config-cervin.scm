(use-modules (gnu)
             (srfi srfi-1))
(use-service-modules desktop)

(primitive-load "config-common.scm")

(define %cervin-base-services
  (modify-services %common-services
    (guix-service-type
     config =>
     (guix-configuration
      (inherit config)
      (substitute-urls '("https://mirror.hydra.gnu.org"
                         "https://bayfront.guixsd.org"
                         "http://192.168.0.20:8081"))
      (extra-options '("--gc-keep-derivations"
                       "--gc-keep-outputs"))))))

(operating-system
  (inherit %common-os)
  (host-name "cervin")
  (kernel-arguments '("acpi_backlight=video thinkpad_acpi.debug=0xffff pcie_aspm=force"))
  (services %cervin-base-services))
