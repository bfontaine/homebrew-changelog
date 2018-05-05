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

  end

  private

  def _lines
    File.readlines(@path)
  rescue
    []
  end
end
