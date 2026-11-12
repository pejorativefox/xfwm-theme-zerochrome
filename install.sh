#!/usr/bin/env bash
#
# Install the zerochrome xfwm4 theme for the current user.
#
# Usage:
#   ./install.sh            install only
#   ./install.sh --set      install and make it the active xfwm4 theme
#
set -euo pipefail

theme_name="zerochrome"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_dir="${script_dir}/${theme_name}"
themes_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/themes"
target_dir="${themes_dir}/${theme_name}"

if [[ ! -f "${source_dir}/xfwm4/themerc" ]]; then
    echo "error: could not find ${source_dir}/xfwm4/themerc" >&2
    exit 1
fi

mkdir -p "${themes_dir}"
rm -rf "${target_dir}"
cp -R "${source_dir}" "${target_dir}"

echo "Installed ${theme_name} to ${target_dir}"

if [[ "${1:-}" == "--set" ]]; then
    if command -v xfconf-query >/dev/null 2>&1; then
        xfconf-query -c xfwm4 -p /general/theme -s "${theme_name}"
        echo "Active xfwm4 theme set to ${theme_name}"
    else
        echo "warning: xfconf-query not found; select ${theme_name} in xfwm4-settings" >&2
    fi
else
    echo "Select '${theme_name}' in xfwm4-settings (or run: $0 --set)"
fi
