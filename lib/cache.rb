# -*- coding: UTF-8 -*-

GLOBAL_PATH = File.expand_path("#{File.dirname(__FILE__)}/../resources/changelogs.txt")

class ChangelogsCache
  attr_reader :path

  def initialize(path = GLOBAL_PATH)
    @path = path
  end

  def url_for_formula(f)
    url_for_formula_name(f.full_name)
  end

  def url_for_formula_name(name)
    prefix = "#{name}:"

    for line in raw_lines
      return line.chomp.split(":", 2)[1] if line.start_with? prefix
    end
    nil
  end

  private

  def raw_lines
    @raw_lines ||= _read_raw_lines
  end

  def _read_raw_lines
    File.readlines(@path)
  rescue
    []
  end
end
