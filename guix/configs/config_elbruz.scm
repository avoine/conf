(use-modules (gnu)
             (linux-nonfree))
(use-service-modules desktop xorg networking dbus cups ssh cuirass)
(use-package-modules admin certs ssh version-control)

(define %my-base-services
  (modify-services %base-services
    (guix-service-type config =>
                       (guix-configuration
                        (inherit config)
                        (substitute-urls '("https://mirror.hydra.gnu.org"
                                           "https://bayfront.guixsd.org"))
                        (extra-options '("--gc-keep-derivations"
                                         "--gc-keep-outputs"))))))
(define %cuirass-specs
  ;; Cuirass specifications to build Guix.
  #~(list `((#:name . "guix")
            (#:url . "git://git.savannah.gnu.org/guix.git")
            (#:branch . "master")
            (#:no-compile? #t)
            (#:load-path . ".")
            (#:proc . drv-list)
            (#:file . #$(local-file "/home/mathieu/conf/guix/cuirass/guix-drv.scm")))))

(operating-system
  (host-name "elbruz")
  (timezone "Europe/Paris")
  (locale "en_US.UTF-8")
  (sudoers-file (plain-file "sudoers"
                            (string-append "root ALL=(ALL) ALL\n"
                                           "%wheel ALL=(ALL) ALL\n"
                                           "mathieu ALL=(ALL) NOPASSWD: ALL")))

  (bootloader (grub-configuration (device "/dev/sda")
                                  (timeout 1)))

  (kernel linux-nonfree)
  (kernel-arguments '("modprobe.blacklist=pcspkr"))

  (initrd (lambda (file-systems . rest)
            (apply base-initrd file-systems
                   rest)))

  (file-systems (cons (file-system
                        (device "my-root")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  (swap-devices '("/dev/sda2"))

  (users (cons (user-account
                (name "mathieu")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/mathieu"))
               %base-user-accounts))

  (packages (cons* nss-certs openssh git %base-packages))

  (services (cons* (slim-service #:auto-login? #t #:default-user "mathieu")
                   (service wpa-supplicant-service-type wpa-supplicant)
                   (service openssh-service-type
                            (openssh-configuration
                             (x11-forwarding? #t)
                             (password-authentication? #f)
                             (permit-root-login 'without-password)))
                   (guix-publish-service #:port 8081 #:host "0.0.0.0")
                   (service cuirass-service-type
                            (cuirass-configuration
                             (interval 30)
                             (use-substitutes? #t)
                             (port 8082)
                             (env (list "GUIX_PACKAGE_PATH=/home/mathieu/conf/guix/packages"))
                             (specifications %cuirass-specs)))
                   (connman-service)
                   (dbus-service)
                   (ntp-service #:allow-large-adjustment? #t)
                   %my-base-services)))
