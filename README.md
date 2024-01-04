# release-tracker-action

[![Lint code base][lintbadge]][lintflow]
[![Move release tags][movebadge]][moveflow]

[lintbadge]: <https://github.com/bewuethr/release-tracker-action/actions/workflows/linter.yml/badge.svg>
[lintflow]:  <https://github.com/bewuethr/release-tracker-action/actions/workflows/linter.yml>
[movebadge]: <https://github.com/bewuethr/release-tracker-action/actions/workflows/releasetracker.yml/badge.svg>
[moveflow]:  <https://github.com/bewuethr/release-tracker-action/actions/workflows/releasetracker.yml>

This action finds the most recent major and (optionally) minor release tags,
and creates or moves tags to point at them.

For example, in a repository with these tags:

```txt
v0.1.0
v0.1.1
v0.1.2
v0.1.3
v0.2.0
v0.2.1
v0.2.2
v0.2.3
v0.2.4
v1.0.0
v1.0.1
v1.1.0
v1.1.1
v1.1.2
```

After running this action, there will be the following additional tags:

```txt
v0.1.0
v0.1.1
v0.1.2
v0.1.3 <-- v0.1
v0.2.0
v0.2.1
v0.2.2
v0.2.3
v0.2.4 <-- v0.2 <-- v0
v1.0.0
v1.0.1 <-- v1.0
v1.1.0
v1.1.1
v1.1.2 <-- v1.1 <-- v1 <-- latest
```

The new tags point at what the existing tags point at, not at the tags
themselves.

This can be used to let consumers of an action use it with a statement like

```yaml
uses: username/action@v1
```

just like the actions provided by GitHub itself do.

If a tag exists already, it is deleted and re-created, pointing at the
correct most recent release.

## Inputs

### `update-latest`

**Optional** If `true`, a special tag `latest` is updated to point at the most
recent semver tag overall. This updates across major versions, i.e., might
break a workflow. Default `false`.

### `update-minor`

**Optional** If `true`, the tags with the format `vX.Y` to point at the most
recent patch version within a minor version are updated. Default `true`.

### `prepend-v`

**Optional** If `true`, tags are expected to look like `vX.Y.Z`, and the moving
tags like `vX.Y` (if enabled) and `vX`. If `false`, the "v" is dropped, and
tags look like `X.Y.Z`, `X.Y`, and `X`:

```txt
0.1.0
0.1.1
0.1.2
0.1.3 <-- 0.1
0.2.0
0.2.1
0.2.2
0.2.3
0.2.4 <-- 0.2 <-- 0
1.0.0
1.0.1 <-- 1.0
1.1.0
1.1.1
1.1.2 <-- 1.1 <-- 1 <-- latest
```

Default `true`.

## Example usage

It makes sense to run this action only when a new semantic versioning tag
has been pushed.

To get all tags, the repository has to be checked out with the complete
history.

The action runs on itself and the current major release is `v1`.

A workflow using this action might look like this:

```yaml
name: Update release tags

# Only run when new semver tag is pushed
on:
  push:
    tags:
      # Switch to '[0-9]+.[0-9]+.[0-9]+' if prepend-v is false
      - v[0-9]+.[0-9]+.[0-9]+

jobs:
  update-release-tags:
    name: Update tags
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:

      - name: Check out code
        uses: actions/checkout@v4
        with:
          # Get complete history
          fetch-depth: 0

      - name: Update major version and latest tags
        uses: bewuethr/release-tracker-action@v1
        env:
          # GitHub token to enable pushing tags
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          # Move "latest" tag
          update-latest: true
          # Don't update the vX.Y tags
          update-minor: false
          # Expect vX.Y.Z format (default)
          prepend-v: true
```
