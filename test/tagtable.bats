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

@test "Creates major tags without prefix" {
	tags=(
		0.1.0
		0.1.1
		0.2.0
		1.0.0-alpha
		1.0.0-beta
		1.0.0
		1.0.1
		1.1.0-alpha
		1.1.0
		1.2.0
		2.0.0-alpha
		2.0.0
	)

	for tag in "${tags[@]}"; do
		git tag "$tag"
	done

	declare -A got
	tagtable got '' false false

	declare -A want=(
		['0']='0.2.0'
		['1']='1.2.0'
		['2']='2.0.0'
	)

	# Debug output for failure
	for newtag in {0..2}; do
		printf '%s --> %s (want %s)\n' \
			"$newtag" "${got["$newtag"]}" "${want["$newtag"]}"
	done

	for key in "${!want[@]}"; do
		[[ ${got["$key"]} == "${want["$key"]}" ]]
	done
}

@test "Creates latest tag" {
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
		v2.1.0-alpha
	)

	for tag in "${tags[@]}"; do
		git tag "$tag"
	done

	declare -A got
	tagtable got 'v' true false

	declare -A want=(
		['latest']='v2.0.0'
	)

	# Debug output for failure
	printf '%s --> %s (want %s)\n' \
		'latest' "${got['latest']}" "${want['latest']}"

	for key in "${!want[@]}"; do
		[[ ${got["$key"]} == "${want["$key"]}" ]]
	done
}
