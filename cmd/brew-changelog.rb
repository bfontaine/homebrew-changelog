# -*- coding: UTF-8 -*-

require_relative "../lib/changelog"
require_relative "../lib/cache"

require "cli/parser"

VERSION = "0.0.1"

def run!
  if ARGV == %w[--version]
    puts "homebrew-changelog v#{VERSION}"
    return
  end

  cache = ChangelogsCache.new

  args = Homebrew::CLI::Parser.new do
  end.parse

  args.named.to_formulae.each do |f|
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
      url = cached_url.sub %r[\{\{version\}\}], f.version.to_s
      open_browser url
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

      You can open its homepage by running:
        brew home #{f.name}

    EOS
  end
end

run!
