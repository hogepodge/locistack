#!/bin/bash
set -x

distro=$(awk -F= '/^ID=/ {gsub(/\"/, "", $2); print $2}' /etc/*release)
export distro=${DISTRO:=$distro}

if [[ ! -z ${DIST_PACKAGES} ]]; then
	case ${distro} in
		debian|ubuntu)
			apt-get install -y --no-install-recommends ${DIST_PACKAGES}
			;;
		centos)
			if [[ ${DIST_PACKAGES} == *"epel-release"* ]]; then
				yum -y install epel-release
			fi
			yum -y --setopt=skip_missing_names_on_install=False install ${DIST_PACKAGES}
			;;
		opensuse|opensuse-leap|opensuse-tumbleweed|sles)
			zypper --non-interactive install --no-recommends ${DIST_PACKAGES}
			;;
		*)
			echo "Unknown distro ${distro}"
			exit 1
			;;
	esac
fi

