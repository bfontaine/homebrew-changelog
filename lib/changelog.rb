# -*- coding: UTF-8 -*-

require "json"

CHANGELOG_FILENAMES = %w[
  changes changelog news
].map do |base|
  ["", ".md", ".markdown", ".text", ".txt"].map { |ext| base + ext }
end.flatten

def formula_all_urls(f)
  urls = [f.homepage]
  [f.stable, f.devel, f.head].each do |version|
    urls << version.url if version
  end

  urls
end

def open_browser(url)
  puts "Opening #{url}..." if ARGV.verbose?
  fork { exec_browser url }
end

class Changelog
  class << self
    def for_formula(formula)
      for impl in implementations
        inst = impl.instance_for_formula formula
        return inst if inst
      end
      nil
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

  attr_reader :formula

  def initialize(formula)
    @formula = formula
  end

  def url
    raise NotImplementedError.new
  end

  protected

  def curl(*args)
    Utils.popen_read("curl", "-fsSL", *args)
  end

  def changelog_filename?(filename)
    CHANGELOG_FILENAMES.include? filename.strip.downcase
  end
end

class GitHubChangelog < Changelog
  class << self
    def instance_for_formula(formula)
      for url in formula_all_urls(formula)
        repo = guess_github_repo(url)
        return self.new(formula, repo) if repo
      end
      nil
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

class GitlabChangelog < Changelog
  class << self
    def instance_for_formula(formula)
      for url in formula_all_urls(formula)
        prefix_repo = guess_gitlab_repo(url)
        return self.new(formula, prefix_repo) if prefix_repo
      end
      nil
    end

    def guess_gitlab_repo(url)
      case url
      # https://gitlab.gnome.org/GNOME/template-glib/blob/master/NEWS
      # https://gitlab.com/procps-ng/procps/blob/master/ChangeLog
      when %r{^(https?://(?:gitlab\.com|gitlab\.[a-z]+\.org))/([^/]+/[^/#]+)}
        [Regexp.last_match[1],
         Regexp.last_match[2].sub(/\.git$/, "")]
      end
    end
  end

  def initialize(formula, prefix_repo)
    super formula
    @prefix, @repo = prefix_repo
  end

  def url
    @url ||= find_url
  end

  private

  def find_url
    # Gitlab doesn't have a 'list files' API
    html = curl("#{@prefix}/#{@repo}/tree/master")
    re = "(?:#{CHANGELOG_FILENAMES.map { |s| Regexp.escape(s) } * "|"})"

    if html =~ %r{<a [^>]*href="(/#{@repo}/blob/master/#{re})"}i
      "#{@prefix}#{Regexp.last_match[1]}"
    end
  end
end
