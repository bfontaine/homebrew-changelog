# Homebrew-Changelog

**Homebrew-Changelog** is a [Homebrew][] tap that adds a `changelog` command to
`brew` that opens a formula’s changelog in your browser.

[Homebrew]: https://brew.sh

## Install

    brew tap bfontaine/changelog

## Usage

    brew changelog [formula ...]

For example:

    brew changelog youtube-dl

The command above opens [`youtube-dl`’s changelog][ydl] in your browser.

[ydl]: https://github.com/rg3/youtube-dl/blob/master/ChangeLog

## Support

This is an alpha version. Right now we only support a subset of formulæ that
host their code on GitHub.

We don’t have any cache or central so `brew changelog` needs to search for a
formula’s changelog every single time you request it.
