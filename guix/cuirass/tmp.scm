(use-modules (guix config)
             (guix store)
             (guix grafts)
             (guix packages)
             (guix derivations)
             (guix monads)
             (guix profiles)
             (gnu packages)
             (gnu packages gnuzilla)
             (srfi srfi-1))

(map manifest-entry-name
     (manifest-entries
      (profile-manifest "/var/guix/profiles/per-user/mathieu/guix-profile")))
