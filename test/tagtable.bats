#!/usr/bin/env bats

load test_helper.bash

@test "Creates major tags" {
	tags=(
		v0.1.0
		v0.1.1
		v0.2.0
		v1.0.0-alpha
		v1.0.0-beta
		v1.0.0
		v1.0.1
		v1.1.0-alpha
		v1.1.0
		v1.2.0
		v2.0.0-alpha
		v2.0.0
	)

	for tag in "${tags[@]}"; do
		git tag "$tag"
	done

	declare -A got
	tagtable got 'v' false false

	declare -A want=(
		['v0']='v0.2.0'
		['v1']='v1.2.0'
		['v2']='v2.0.0'
	)

	# Debug output for failure
	for newtag in v{0..2}; do
		printf '%s --> %s (want %s)\n' \
			"$newtag" "${got["$newtag"]}" "${want["$newtag"]}"
	done

	for key in "${!want[@]}"; do
		[[ ${got["$key"]} == "${want["$key"]}" ]]
	done
}
