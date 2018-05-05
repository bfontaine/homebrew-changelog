# -*- coding: UTF-8 -*-

require_relative "../lib/changelog"
require_relative "../lib/cache"

VERSION = "0.0.1"

def run!
  if ARGV == %w[--version]
    puts "homebrew-changelog v#{VERSION}"
    return
  end

  cache = ChangelogsCache.new

  ARGV.formulae.each do |f|
    cached_url = cache.url_for_formula(f)
    if cached_url == ""
      puts <<~EOS
        The formula '#{f.name}' doesn't have any Changelog that we know of.
        Please submit a pull-request if you think it should:
          https://github.com/bfontaine/homebrew-changelog/blob/master/CONTRIBUTING.md

      EOS
      next
    end

    unless cached_url.nil?
      open_browser cached_url
      next
    end

    url = Changelog.url_for_formula(f)

    if url
      open_browser url
      next
    end

    puts <<~EOS
      I couldn't find a Changelog for the formula '#{f.name}'.
      Please submit a pull-request if you know any:
          https://github.com/bfontaine/homebrew-changelog/blob/master/CONTRIBUTING.md

    EOS
  end
end

run!
