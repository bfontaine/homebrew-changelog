# Homebrew-Changelog

**Homebrew-Changelog** is a [Homebrew][] tap that adds a `changelog` command to
`brew` to open a formula’s changelog in your browser.

[Homebrew]: https://brew.sh

## Install

    brew tap bfontaine/changelog

## Usage

    brew changelog [formula ...]

For example:

    brew changelog git

The command above opens `git`’s in your browser.

## Caveats

This is an alpha version. All formulas have different ways of managing their
changelog (if they have one), so it’s really hard to make a tool that works for
all of them.

`brew changelog` can find changelogs in the following cases:
* Installed formulas
* GitHub-hosted formulas
* some Gitlab-hosted formulas
