#!/bin/sh
GLIBC_VER_MIN=2.26
APT_VER_MIN=1.1
set -eu
available() { command -v "$1" >/dev/null; }
first_of() { for c in "$@"; do if available "$c"; then echo "$c"; return; fi; done; return 1; }
error() { exec >&2; printf "Error: %s\n" "$*"; exit 1; }
newer() { [ "$(printf "%s\n%s" "$1" "$2"|sort -V|head -n1)" = "$2" ]; }
supported() { newer "$2" "$3" || error "Unsupported $1 version $2. Only versions >=$3 supported."; }
glibc_supported() { supported glibc "$(ldd --version 2>/dev/null|head -n1|grep -oE '[0-9]+\.[0-9]+$' || true)" "$GLIBC_VER_MIN"; }
apt_error() { error 'The "apt-get update" command is not working. Fix your system configuration.'; }
apt_supported() { supported apt "$(apt-get -v|head -n1|cut -d' ' -f2)" "$APT_VER_MIN"; }
main() {
  glibc_supported
  case "$(uname -m)" in
    aarch64|x86_64) ;;
    *) error "Unsupported architecture $(uname -m). Only 64-bit x86 or ARM supported.";;
  esac
  case "$(whoami)" in
    root) sudo="";;
    *) sudo="$(first_of sudo doas run0 pkexec sudo-rs)" || error "Install sudo/doas/run0/pkexec/sudo-rs to proceed.";;
  esac
  case "$(first_of curl wget)" in
    wget) curl="wget -qO-";;
    *) curl="curl -fsS";;
  esac
  if available apt-get && apt_supported; then
    export DEBIAN_FRONTEND=noninteractive
    if ! available curl && ! available wget; then
      $sudo apt-get update >/dev/null 2>&1 || apt_error
      $sudo apt-get install -y curl >/dev/null 2>&1
    fi
    $curl "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg" | $sudo install -DTm644 /dev/stdin /usr/share/keyrings/brave-browser-archive-keyring.gpg >/dev/null 2>&1
    $curl "https://brave-browser-apt-release.s3.brave.com/brave-browser.sources" | $sudo install -DTm644 /dev/stdin /etc/apt/sources.list.d/brave-browser-release.sources >/dev/null 2>&1
    $sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list >/dev/null 2>&1
    $sudo apt-get update >/dev/null 2>&1 || apt_error
    $sudo apt-get install -y brave-browser >/dev/null 2>&1
  elif available dnf; then
    if dnf --version|grep -q dnf5; then
      $sudo dnf config-manager addrepo --overwrite --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo >/dev/null 2>&1
    else
      $sudo dnf install -y 'dnf-command(config-manager)' >/dev/null 2>&1
      $sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo >/dev/null 2>&1
    fi
    $sudo dnf install -y brave-browser >/dev/null 2>&1
  elif available eopkg; then
    $sudo eopkg update-repo -y >/dev/null 2>&1
    $sudo eopkg install -y brave >/dev/null 2>&1
  elif available pacman; then
    if pacman -Ss brave-browser >/dev/null 2>&1; then
      $sudo pacman -Sy --needed --noconfirm brave-browser >/dev/null 2>&1
    else
      aur_helper="$(first_of paru pikaur yay)" || error "Install paru/pikaur/yay to proceed."
      $aur_helper -Sy --needed --noconfirm brave-bin >/dev/null 2>&1
    fi
  elif available zypper; then
    $sudo zypper --non-interactive addrepo --gpgcheck --repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo >/dev/null 2>&1
    $sudo zypper --non-interactive --gpg-auto-import-keys refresh >/dev/null 2>&1
    $sudo zypper --non-interactive install brave-browser >/dev/null 2>&1
  elif available yum; then
    available yum-config-manager || $sudo yum install yum-utils -y >/dev/null 2>&1
    $sudo yum-config-manager -y --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo >/dev/null 2>&1
    $sudo yum install brave-browser -y >/dev/null 2>&1
  elif available rpm-ostree; then
    available curl || available wget || error "Install curl/wget to proceed."
    $curl https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo | $sudo install -DTm644 /dev/stdin /etc/yum.repos.d/brave-browser.repo >/dev/null 2>&1
    $sudo rpm-ostree install -y --idempotent brave-browser >/dev/null 2>&1
  else
    error "No supported package manager found. Supported: apt/dnf/eopkg/pacman/paru/pikaur/yay/rpm-ostree/yum/zypper." \
          "If you want better support, file an issue at https://github.com/brave/install.sh/issues" \
          "$(uname -srvmo || true)" "$(cat /etc/os-release || true)"
  fi
}
main
