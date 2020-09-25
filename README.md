# release-tracker-action

![Linting](https://github.com/bewuethr/release-tracker-action/workflows/Linting/badge.svg)
![Move release tags](https://github.com/bewuethr/release-tracker-action/workflows/Move%20release%20tags/badge.svg)

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
v1.1.2 <-- v1.1 <-- v1
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

## Example usage

It makes sense to run this action only when a new semantic versioning tag
has been pushed.

To get all tags, the repository has to be checked out with the complete
history.

The action runs on itself and the current major release is `v1`.

A workflow using this action might look like this:

```yaml
# Only run when new semver tag is pushed
on:
  push:
    tags:
      - v[0-9]+.[0-9]+.[0-9]+

name: Move release tags

jobs:
  update-release-tags:
    runs-on: ubuntu-latest
    steps:

      - name: Check out code
        uses: actions/checkout@v2
        with:
          # Get complete history
          fetch-depth: 0
          # Always check out a branch
          ref: master

      - name: Update release tags for latest major and minor releases
        uses: bewuethr/release-tracker-action@v1
```
