#!/bin/bash
# Prepare a deployment for SBCIMG Base Installation
# This is the firstrun script which simply installs the needed repositories

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root" 2>&1
  exit 1
else

# NEED TO ADD REPOS MANUALLY FOR NOW
# Pi:
#deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi firmware

#Debian:
#  echo "deb http://deb.debian.org/debian/ stretch non-free main
#        deb-src http://deb.debian.org/debian/ stretch non-free main
#        deb http://security.debian.org/debian-security stretch/updates non-free main contrib
#        deb-src http://security.debian.org/debian-security stretch/updates non-free main contrib
        # stretch-updates, previously known as 'volatile'
#        deb http://deb.debian.org/debian/ stretch-updates non-free main contrib
#       deb-src http://deb.debian.org/debian/ stretch-updates non-free main contrib
#  " > /etc/apt/sources.list

  apt update

  apt install --yes git screen dialog gnupg nano apt-utils
  
  # Setup default account info
  git config --global user.email "nems@baldnerd.com"
  git config --global user.name "NEMS Linux"

  cd /root
  mkdir sbcimg
  cd sbcimg

  git clone https://github.com/Cat5TV/sbcimg-base

  cd /root/sbcimg/sbcimg-base

  # Configure default locale
  apt install -y locales
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LC_TIME=en_US.UTF-8
  if grep -q "# en_US.UTF-8" /etc/locale.gen; then
    /bin/sed -i -- 's,# en_US.UTF-8,en_US.UTF-8,g' /etc/locale.gen
  fi
  locale-gen
  #dpkg-reconfigure locales # Set second screen to UTF8
  
  # Make it so SSH does not load the locale from the connecting machine (causes problems on Pine64)
  # This requires the user to re-connect
  sed -i -e 's/    SendEnv LANG LC_*/#   SendEnv LANG LC_*/g' /etc/ssh/ssh_config

  echo System Prepped... re-connect, run screen, then run build.sh
fi
