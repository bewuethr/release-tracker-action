#!/usr/bin/env bats

load test_helper.bash

@test "Sorts version core tags according to spec" {
	tags=(
		v0.1.0
		v0.1.1
		v0.2.0
		v1.0.0
		v1.0.1
		v1.1.0
		v1.2.0
		v2.0.0
	)

	for tag in "${tags[@]}"; do
		git tag "$tag"
	done

	run gettags 'v'

	# Debug output for failure
	{
		printf '%s\t%s\n' 'got' 'want'
		paste <(echo "$output") <(printf '%s\n' "${tags[@]}")
	} | column -t

	for ((i = 0; i < ${#tags[@]}; ++i)); do
		[[ ${lines[i]} == "${tags[i]}" ]]
	done
}

@test "Sorts tags with pre-releases according to spec" {
	tags=(
		v1.0.0-alpha
		v1.0.0-alpha.1
		v1.0.0-alpha.beta
		v1.0.0-beta
		v1.0.0-beta.2
		v1.0.0-beta.11
		v1.0.0-rc.1
		v1.0.0
	)

	for tag in "${tags[@]}"; do
		git tag "$tag"
	done

	run gettags 'v'

	# Debug output for failure
	{
		printf '%s\t%s\n' 'got' 'want'
		paste <(printf '%s\n' "${lines[@]}") <(printf '%s\n' "${tags[@]}")
	} | column -t

	for ((i = 0; i < ${#tags[@]}; ++i)); do
		[[ ${lines[i]} == "${tags[i]}" ]]
	done
}
