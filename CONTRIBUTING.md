# Contributing to Homebrew-Changelog

## Report a bug

<https://github.com/bfontaine/homebrew-changelog/issues/new>

## Add a formula changelog

We keep a cache for known changelogs in [`resources/changelogs.txt`][cache].
Please make a pull-request to add a URL for the formula in that file.

The format is:

```
<formula>: <url>
```

Formulas that are known not to have a changelog have an empty URL. Those with
a changelog URL per version can use the `{{version}}` placeholder.

Note we only list core formulas in that file. Please keep the file sorted.

[cache]: https://github.com/bfontaine/homebrew-changelog/blob/master/resources/changelogs.txt
