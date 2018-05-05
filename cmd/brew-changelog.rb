# -*- coding: UTF-8 -*-

require "json"
require "shellwords"

VERSION = "0.0.1"

class Formula
  def all_urls
    @all_urls ||= [
      homepage,
      (stable.url if stable),
      (devel.url if devel),
      (head.url if head),
    ].compact
  end
end

class Changelog
  def url
    raise NotImplementedError.new
  end

  class << self

    def for_formula(formula)
      for impl in implementations
        inst = impl.instance_for_formula formula
        return inst if inst
      end
    end

    def url_for_formula(formula)
      inst = for_formula(formula)
      inst.url if inst
    end

    def inherited(subclass)
      implementations << subclass
    end

    protected

    def instance_for_formula(formula); end

    private

    def implementations
      @implementations ||= []
    end
  end

  def initialize(formula)
    @formula = formula
  end

  protected

  def curl(*args)
    `curl -fsSL #{Shellwords.join(args)}`
  end

  def changelog_filename?(filename)
    %w[
      changes
      changes.md
      changes.markdown
      changes.txt
      changelog
      changelog.md
      changelog.markdown
      changelog.txt
    ].include? filename.strip.downcase
  end
end

class GitHubChangelog < Changelog
  class << self
    def instance_for_formula(formula)
      for url in formula.all_urls
        repo = guess_github_repo(url)
        return self.new(formula, repo) if repo
      end
    end

    def guess_github_repo(url)
      repo = case url
             when %r{^https?://(?:codeload\.)?github\.com/([^/]+/[^/#]+)}
               Regexp.last_match[1]
             when %r{^(?:ssh|git)://git@github:([^/]+/[^/#]+)}
               Regexp.last_match[1]
             end

      repo.sub(/\.git$/, "") if repo
    end
  end

  def initialize(formula, repo)
    super formula
    @repo = repo
  end

  def url
    @url ||= find_url
  end

  private

  def find_url
    contents = JSON.parse curl("https://api.github.com/repos/#{@repo}/contents")
    d = contents.find do |file|
          file["type"] == "file" && changelog_filename?(file["name"])
        end

    d["html_url"] if d
  end
end

def open_browser(url)
  if OS.mac?
    system "xdg-open", url
  elsif OS.linux?
    system "open", url
  else
    puts url
  end
end

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
