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
    [4.4]='4.4.0'
    [devel]='devel'
    [next]='next'
)

declare -A os_identifiers=(
    [focal]='ubuntu-2004'
    [jammy]='ubuntu-2204'
    [noble]='ubuntu-2404'
    [bullseye]='debian-11'
    [bookworm]='debian-12'
    [centos7]='centos-7'
    [rockylinux8]='centos-8'
    [rockylinux9]='rhel-9'
    [opensuse155]='opensuse-155'
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
            bullseye|bookworm) template='debian'
            ;;
            centos7|rockylinux8) template='centos'
            ;;
            rockylinux9) template='rockylinux'
            ;;
            opensuse155) template='opensuse'
            ;;
        esac

        template="Dockerfile-${template}.template"

        { generated_warning; cat "$template"; } > "$dir/Dockerfile"

        sed -ri \
            -e "s/%%VARIANT%%/${variant}/" \
            -e "s/%%R_VERSION%%/${r_versions[$version]}/" \
            -e "s/%%OS_IDENTIFIER%%/${os_identifiers[$variant]}/" \
            "$dir/Dockerfile"

        cp docker-compose.test.yml $dir

        # Add MAJOR.MINOR.PATCH version tags
        mkdir -p "$dir/hooks" && cp post_push.template.sh "$dir/hooks/post_push"
        sed -ri \
            -e "s/%%TAG%%/${r_versions[$version]}-${variant}/" \
            "$dir/hooks/post_push"
    done
done
