kind: manual

# gunwald's GNOME Shell extensions, enabled by default in
# disable-ext-validator.bst: Glean (clipboard history and quick notes), Drop to
# Shell (Quick Settings as a side pane that also hosts tray icons, the clock
# as a Today page in the overview), Sheaf (gather an app's windows across
# workspaces, Super+Tab) and Tally (system monitor widgets).
#
# Each one is built from upstream main with upstream's own scripts/package.py,
# the step its CI uses for the published build, so the image ships the same
# archive. The image workflow tracks main; the UUIDs below must match the
# enabled-extensions list.
sources:
- kind: git_repo
  url: gitlab:gunwald/glean.git
  track: main
  ref: 0ddb79b58a87bb8fdfad393afa35a4676d61e424
  directory: glean
- kind: git_repo
  url: gitlab:gunwald/drop-to-shell.git
  track: main
  ref: 13577fa0dfb1e2a6b000f441695e76ffddbafaa5
  directory: drop-to-shell
- kind: git_repo
  url: gitlab:gunwald/sheaf.git
  track: main
  ref: a42031e0ca8c027bc83a7c9b887ac60cb982bdf9
  directory: sheaf
- kind: git_repo
  url: gitlab:gunwald/tally.git
  track: main
  ref: cec5e8ccf26da181582a9b528bc95822ce0e6f66
  directory: tally

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/gettext.bst
- freedesktop-sdk.bst:components/jq.bst

depends:
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:core/gnome-shell.bst

variables:
  strip-binaries: ""

config:
  build-commands:
  - |
    for repo in glean drop-to-shell sheaf tally; do
      python3 "${repo}/scripts/package.py"
    done

  install-commands:
  - |
    for entry in glean:glean@gunwald.gitlab.com \
        drop-to-shell:drop-to-shell@gunwald.gitlab.com \
        sheaf:sheaf@gunwald.gitlab.com \
        tally:tally@gunwald.gitlab.com; do
      repo="${entry%%:*}"
      uuid="${entry#*:}"
      # An upstream UUID change has to reach enabled-extensions too.
      jq -e --arg uuid "${uuid}" '.uuid == $uuid' "${repo}/metadata.json" > /dev/null || {
        echo "ERROR: ${repo} no longer has the UUID ${uuid}" >&2
        exit 1
      }
      dest="%{install-root}%{datadir}/gnome-shell/extensions/${uuid}"
      install -d "${dest}"
      python3 -m zipfile -e "${repo}/dist/${uuid}.shell-extension.zip" "${dest}"
      # The archive leaves schema compilation to gnome-extensions install,
      # which a system-wide extension never goes through.
      glib-compile-schemas --strict "${dest}/schemas"
      for schema in "${dest}"/schemas/*.gschema.xml; do
        install -Dm644 "${schema}" \
          "%{install-root}%{datadir}/glib-2.0/schemas/$(basename "${schema}")"
      done
    done
