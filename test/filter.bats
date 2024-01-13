#!/usr/bin/env bats

load test_helper.bash

@test "Matches v1.0.0" {
	export -f filter
	run bash -c 'echo "v1.0.0" | filter "v"'
	[[ $output == 'v1.0.0' ]]
}

@test "Matches v1.0.0-alpha" {
	export -f filter
	run bash -c 'echo "v1.0.0-alpha" | filter "v"'
	[[ $output == 'v1.0.0-alpha' ]]
}

@test "Matches v1.0.0-1" {
	export -f filter
	run bash -c 'echo "v1.0.0-1" | filter "v"'
	[[ $output == 'v1.0.0-1' ]]
}

@test "Matches v1.0.0-alpha.2" {
	export -f filter
	run bash -c 'echo "v1.0.0-alpha.2" | filter "v"'
	[[ $output == 'v1.0.0-alpha.2' ]]
}

@test "Does not match non-digit" {
	export -f filter
	run bash -c 'echo "v1.0.a" | filter "v"'
	[[ -z $output ]]
}

@test "Does not match leading zero" {
	export -f filter
	run bash -c 'echo "v01.0.0" | filter "v"'
	[[ -z $output ]]
}

@test "Does not match incomplete version" {
	export -f filter
	run bash -c 'echo "v1.0" | filter "v"'
	[[ -z $output ]]
}

@test "Does not match trailing period" {
	export -f filter
	run bash -c 'echo "v1.0." | filter "v"'
	[[ -z $output ]]
}

@test "Does not match trailing period on pre-release" {
	export -f filter
	run bash -c 'echo "v1.0.0-alpha." | filter "v"'
	[[ -z $output ]]
}

@test "Does not match leading period on pre-release" {
	export -f filter
	run bash -c 'echo "v1.0.0-.alpha" | filter "v"'
	[[ -z $output ]]
}

@test "Does not match patchier than patch" {
	export -f filter
	run bash -c 'echo "v1.0.0.0" | filter "v"'
	[[ -z $output ]]
}

@test "Does not match empty pre-release" {
	export -f filter
	run bash -c 'echo "v1.0.0-" | filter "v"'
	[[ -z $output ]]
}
