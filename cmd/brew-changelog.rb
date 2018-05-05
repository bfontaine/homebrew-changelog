# -*- coding: UTF-8 -*-

require "json"
require "shellwords"

require_relative "../lib/changelog"

VERSION = "0.0.1"

def run!
  if ARGV == %w[--version]
    puts "homebrew-changelog v#{VERSION}"
    return
  end

  ARGV.formulae.each do |f|
    url = Changelog.url_for_formula(f)
    open_browser url if url
  end
end

run!
