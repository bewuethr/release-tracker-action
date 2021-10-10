# release-tracker-action

[![Lint code base][lintflow]][lintbadge]
[![Move release tags][moveflow]][movebadge]

[lintflow]:  <https://github.com/bewuethr/release-tracker-action/actions/workflows/lint.yml>
[lintbadge]: <https://github.com/bewuethr/release-tracker-action/actions/workflows/lint.yml/badge.svg>
[moveflow]:  <https://github.com/bewuethr/release-tracker-action/actions/workflows/releasetracker.yml>
[movebadge]: <https://github.com/bewuethr/release-tracker-action/actions/workflows/releasetracker.yml/badge.svg>

This action finds the most recent major and minor release tags and creates
or moves tags to point at them.

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
      - v[0-9]+.[0-9]+.[0-9]+

jobs:
  update-release-tags:
    name: Update tags
    runs-on: ubuntu-latest
    steps:

      - name: Check out code
        uses: actions/checkout@v2
        with:
          # Get complete history
          fetch-depth: 0

      - name: Update vX, vX.Y, and latest tags
        uses: bewuethr/release-tracker-action@v1
        env:
          # GitHub token to enable pushing tags
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          # Move "latest" tag
          update-latest: true
```
