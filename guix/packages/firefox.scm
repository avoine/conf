(define-module (firefox)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (autoconf)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages python)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages assembly)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages libcanberra)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages libreoffice)  ;for hunspell
  #:use-module (gnu packages image)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages mit-krb5)
  #:use-module (gnu packages video)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages zip)
  #:use-module ((guix licenses) #:prefix license:))

(define-public firefox
  (package
    (name "firefox")
    (version "50.1.0")
    (build-system gnu-build-system)
    (inputs `(("autoconf@2.13" ,autoconf-2.13)
              ("automake" ,automake)
              ("which" ,which)
              ("pkg-config" ,pkg-config)
              ("bash" ,bash)
              ("perl" ,perl)
              ("yasm" ,yasm)
              ("util-linux" ,util-linux)
              ("pulseaudio" ,pulseaudio)
              ("libxt" ,libxt)
              ("libxcomposite" ,libxcomposite)
              ("gtk-2" ,gtk+-2)
              ("gtk-3" ,gtk+)
              ("glib" ,glib)
              ("gst-libav" ,gst-libav)
              ("alsa-lib" ,alsa-lib)
              ("bzip2" ,bzip2)
              ("cairo" ,cairo)
              ("cups" ,cups)
              ("dbus-glib" ,dbus-glib)
              ("gdk-pixbuf" ,gdk-pixbuf)
              ("gstreamer" ,gstreamer)
              ("gst-plugins-base" ,gst-plugins-base)
              ("gtk+" ,gtk+-2)
              ("pango" ,pango)
              ("freetype" ,freetype)
              ("hunspell" ,hunspell)
              ("libcanberra" ,libcanberra)
              ("libgnome" ,libgnome)
              ("libjpeg-turbo" ,libjpeg-turbo)
              ("libxft" ,libxft)
              ("libevent" ,libevent)
              ("libxinerama" ,libxinerama)
              ("libxscrnsaver" ,libxscrnsaver)
              ("libffi" ,libffi)
              ("libvpx" ,libvpx)
              ("ffmpeg" ,ffmpeg)
              ("icu4c" ,icu4c)
              ("pixman" ,pixman)
              ("mesa" ,mesa)
              ("mit-krb5" ,mit-krb5)
              ("nspr" ,nspr)
              ("nss" ,nss)
              ("sqlite" ,sqlite)
              ("startup-notification" ,startup-notification)
              ("gconf" ,gconf)
              ("libpng" ,libpng)
              ("libjpeg" ,libjpeg)
              ("zlib" ,zlib)
              ("unzip" ,unzip)
              ("zip" ,zip)
              ("python@2.7" ,python-2.7)))     ;for the libext2fs Info manual
    (source
     (origin
       (method url-fetch)
       (uri "https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/50.1.0/source/firefox-50.1.0.source.tar.xz")
       (sha256
        (base32
         "1965dad701hf735xwpvgfm5y477l1crlazxf2mvhrvcypz69pfsl"))))
    (arguments
     '(#:tests? #f
       #:validate-runpath? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure) ; no configure script
         (add-after
          'unpack 'arrange-to-link-libxul-with-libraries-it-might-dlopen
          (lambda _
            ;; libxul.so dynamically opens libraries, so here we explicitly
            ;; link them into libxul.so instead.
            ;;
            ;; TODO: It might be preferable to patch in absolute file names in
            ;; calls to dlopen or PR_LoadLibrary, but that didn't seem to
            ;; work.  More investigation is needed.
            (substitute* "toolkit/library/moz.build"
              (("^# This needs to be last")
               "OS_LIBS += [
    'GL', 'gnome-2', 'canberra', 'Xss', 'cups', 'gssapi_krb5',
    'gstreamer-1.0', 'gstapp-1.0', 'gstvideo-1.0', 'pulse', 'avcodec', 'avutil']\n\n"))
            #t))
         (add-before 'build 'patch-binutils
           (lambda _
             (substitute* "./xpcom/components/Module.h"
                          (("protected") "default"))
             (substitute* "./dom/media/platforms/ffmpeg/FFmpegVideoDecoder.cpp"
                          (("return AV_CODEC_ID_VP9;") ";"))))
         (add-before 'build 'write-config
           (lambda _
             (call-with-output-file "mozconfig"
               (lambda (port) (format port
                                      "ac_add_options --disable-necko-wifi
ac_add_options --disable-gconf
ac_add_options --enable-system-sqlite
ac_add_options --enable-pulseaudio
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --enable-optimize
ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --enable-ffmpeg
ac_add_options --with-pthreads
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-zlib
")
                       (format port (string-append
                                     "ac_add_options --prefix=" (assoc-ref %outputs "out")))))))
         (replace 'build
           (lambda _
             (setenv "SHELL" (which "bash"))
             (setenv "CONFIG_SHELL" (which "bash"))
             (setenv "AUTOCONF" (which "autoconf"))
             (system "make -f client.mk")))
         (replace 'install
           (lambda _
             (system "make -f client.mk install"))))))
    (synopsis "Firefox")
    (description
     "firefox")
    (home-page "lol")
    (license license:gpl2)))
