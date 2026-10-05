kind: meson

# gnome-software-next, a downstream fork of GNOME Software, in place of
# gnome-build-meta's core/gnome-software.bst (which Dakota does not ship).
# Dependencies and options follow that upstream element; keep them in sync
# when the gnome-build-meta junction moves to a new GNOME release.
sources:
- kind: git_repo
  url: gnome_gitlab:user_c1a5830a/gnome-software-next.git
  track: wip/core
  ref: 51.0-669-g57f2c3c01cac524b8b5b4671f1bd6cc26b176f25
# The release tarballs include this submodule; a git checkout does not.
- kind: git_repo
  url: gnome_gitlab:mwleeds/gnome-pwa-list.git
  directory: subprojects/gnome-pwa-list
  ref: 48ac9f7ed6a639eab7648f3e3b19105694eaf306

build-depends:
- gnome-build-meta.bst:buildsystems/meson.bst
- gnome-build-meta.bst:sdk/gtk-doc.bst
- gnome-build-meta.bst:sdk/sysprof-minimal.bst
- freedesktop-sdk.bst:components/itstool.bst

depends:
- gnome-build-meta.bst:core-deps/fwupd.bst
- gnome-build-meta.bst:core-deps/glib-testing.bst
- gnome-build-meta.bst:core-deps/gnome-online-accounts.bst
- gnome-build-meta.bst:core-deps/malcontent.bst
- gnome-build-meta.bst:core-deps/snapd-glib.bst
- gnome-build-meta.bst:core/gnome-desktop.bst
- gnome-build-meta.bst:sdk/adwaita-icon-theme.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gsettings-desktop-schemas.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/libadwaita.bst
- gnome-build-meta.bst:sdk/libsecret.bst
- gnome-build-meta.bst:sdk/libsoup.bst
- freedesktop-sdk.bst:components/appstream.bst
- freedesktop-sdk.bst:components/flatpak.bst
- freedesktop-sdk.bst:components/libgudev.bst
- freedesktop-sdk.bst:components/libxmlb.bst
- freedesktop-sdk.bst:components/polkit.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

runtime-depends:
- gnome-build-meta.bst:core-deps/gnome-app-list.bst

variables:
  meson-local: >-
    -Dfwupd=true
    -Dpolkit=true
    -Dflatpak=true
    -Deos_updater=true
    -Dpackagekit=false
    -Dsnap=true
    -Dsystemd-sysupdate=true
