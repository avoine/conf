(define (spec->packages spec)
  (call-with-values (lambda ()
                      (specification->package+output spec)) list))

(define packages-list
  '("acpi"
    "acpica"
    "alsa-utils"
    "autoconf"
    "automake"
    "bash"
    "cmst"
    "connman"
    "cuirass"
    "cups"
    "curl"
    "emacs"
    "emacs-evil"
    "emacs-f"
    "emacs-flx"
    "emacs-guix"
    "emacs-ido-ubiquitous"
    "emacs-magit-popup"
    "emacs-markdown-mode"
    "emacs-mu4e-alert"
    "emacs-paredit"
    "emacs-pdf-tools"
    "emacs-rainbow-delimiters"
    "emacs-s"
    "emacs-smex"
    "ethtool"
    "file"
    "firefox"
    "font-dejavu"
    "gcc-toolchain"
    "geiser"
    "git"
    "git:send-email"
    "global"
    "gnupg"
    "guile"
    "htop"
    "icu4c"
    "isync"
    "libevent"
    "libtool"
    "linux-nonfree"
    "lzop"
    "magit"
    "make"
    "mesa"
    "mplayer"
    "mu"
    "ncdu"
    "ncurses"
    "nss"
    "ntp"
    "openssh"
    "openssl"
    "pavucontrol"
    "perl"
    "pkg-config"
    "powertop"
    "pulseaudio"
    "python"
    "python-wrapper"
    "qemu"
    "qt"
    "ratpoison-xrandr"
    "rsync"
    "screen"
    "setxkbmap"
    "slim"
    "sqlite"
    "strace"
    "texi2html"
    "texinfo"
    "tree"
    "unzip"
    "vim"
    "vlc"
    "w3m"
    "wget"
    "wpa-supplicant"
    "xev"
    "xrandr"
    "xrdb"
    "yasm"
    "zip"
  ))

(packages->manifest
 (map spec->packages packages-list))
