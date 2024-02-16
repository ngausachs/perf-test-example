#!/bin/sh

# shellcheck disable=SC3043

# sometimes this job fails with 
# Could not get lock /var/lib/dpkg/lock-frontend or similar.
# This means that a previous update process hasn't finished yet
# Writing a wrapper function to improve robustness for this

betterAptGetInstall(){
  local lSuccess=1 # 0 - success; #0 - not finished yet
  local lCrtRetry=0 lMaxRetries=10

  while [ $lSuccess -ne 0 ]; do
    # shellcheck disable=SC2068
    sudo apt-get -y -qq install $@
    lSuccess=$?
    if [ $lSuccess -eq 0 ]; then
      echo ">>>>>>>>>>>>>>>> Libraries installed successfully"
    else
      lCrtRetry=$((lCrtRetry+1))
      if [ $lCrtRetry -gt $lMaxRetries ]; then
        echo ">>>>>>>>>>>>>>>> ERROR: Could not install the required libraries after the maximum number of retries!"
        return 1
      fi
      echo ">>>>>>>>>>>>>>>> ERROR: Installation of required libraries failed with code $lSuccess. Retrying $lCrtRetry/$lMaxRetries ..."
      sleep 10
    fi
  done
}

echo ">>>>>>>>>>>>>>>> Updating OS software ..."
sudo apt-get -qq -y update

echo ">>>>>>>>>>>>>>>> Installing prerequisites..."
betterAptGetInstall ca-certificates curl gnupg2 fuse-overlayfs || exit 1

# shellcheck disable=1091
. /etc/os-release
echo "Installing buildah for OS release ${VERSION_ID}..."
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -fsL "https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add - &&

echo ">>>>>>>>>>>>>>>> Updating base libraries again..."
sudo apt-get -qq -y update

echo ">>>>>>>>>>>>>>>> Installing buildah..."
betterAptGetInstall buildah || exit 1

echo ">>>>>>>>>>>>>>>> Machine prepared"
