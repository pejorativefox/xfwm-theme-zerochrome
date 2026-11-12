#!/usr/bin/env bash
#
# Uninstall the zerochrome xfwm4 theme for the current user.
#
set -euo pipefail

theme_name="zerochrome"
themes_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/themes"
target_dir="${themes_dir}/${theme_name}"

if [[ ! -d "${target_dir}" ]]; then
    echo "${theme_name} is not installed at ${target_dir}"
    exit 0
fi

if [[ ! -f "${target_dir}/xfwm4/themerc" ]]; then
    echo "error: ${target_dir} does not look like a ${theme_name} install; refusing to remove it" >&2
    exit 1
fi

rm -rf "${target_dir}"
echo "Removed ${target_dir}"

# If zerochrome was the active theme, point xfwm4 back at the default theme
# so it does not keep referring to a theme that no longer exists.
if command -v xfconf-query >/dev/null 2>&1; then
    current_theme="$(xfconf-query -c xfwm4 -p /general/theme 2>/dev/null || true)"
    if [[ "${current_theme}" == "${theme_name}" ]]; then
        if xfconf-query -c xfwm4 -p /general/theme -s Default; then
            echo "Active xfwm4 theme reset to Default"
        else
            echo "warning: could not reset the active xfwm4 theme; select one in xfwm4-settings" >&2
        fi
    fi
fi
