setup() {
	# shellcheck source=/dev/null
	source tagupdater

	local repo='/tmp/tagupdater-testrepo'
	mkdir --parents "$repo"
	git -C "$repo" init --quiet

	if [[ -z $(git -C "$repo" config --get user.name) ]]; then
		git -C "$repo" config user.name "Integration Test"
	fi
	if [[ -z $(git -C "$repo" config --get user.email) ]]; then
		git -C "$repo" config user.email "integration.test@example.com"
	fi

	cd /tmp/tagupdater-testrepo || return 1
}

teardown() {
	rm -rf /tmp/tagupdater-testrepo
}
