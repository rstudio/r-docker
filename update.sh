#!/bin/bash
set -Eeuo pipefail

declare -A r_versions=(
    [3.1]='3.1.3'
    [3.2]='3.2.5'
    [3.3]='3.3.3'
    [3.4]='3.4.4'
    [3.5]='3.5.3'
    [3.6]='3.6.3'
    [4.0]='4.0.5'
    [4.1]='4.1.3'
    [4.2]='4.2.3'
    [4.3]='4.3.3'
    [4.4]='4.4.3'
    [4.5]='4.5.0'
    [devel]='devel'
    [next]='next'
)

declare -A os_identifiers=(
    [focal]='ubuntu-2004'
    [jammy]='ubuntu-2204'
    [noble]='ubuntu-2404'
    [bookworm]='debian-12'
    [centos7]='centos-7'
    [rockylinux8]='centos-8'
    [rockylinux9]='rhel-9'
    [opensuse156]='opensuse-156'
)

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#

	EOH
}

for version in "${!r_versions[@]}"; do
    for variant in "${!os_identifiers[@]}"; do
        dir="$version/$variant"

        mkdir -p $dir

        case "$variant" in
            focal|jammy|noble) template='ubuntu'
            ;;
            bookworm) template='debian'
            ;;
            centos7|rockylinux8) template='centos'
            ;;
            rockylinux9) template='rockylinux'
            ;;
            opensuse156) template='opensuse'
            ;;
        esac

        template="Dockerfile-${template}.template"

        { generated_warning; cat "$template"; } > "$dir/Dockerfile"

        sed -ri \
            -e "s/%%VARIANT%%/${variant}/" \
            -e "s/%%R_VERSION%%/${r_versions[$version]}/" \
            -e "s/%%OS_IDENTIFIER%%/${os_identifiers[$variant]}/" \
            "$dir/Dockerfile"

        # Record MAJOR.MINOR.PATCH version as the tag alias
        echo "${r_versions[$version]}" > "$dir/version.txt"
    done
done
